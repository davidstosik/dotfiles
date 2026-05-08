# frozen_string_literal: true

require "find"
require "fileutils"
require "minitest/autorun"
require "tmpdir"

require_relative "../../lib/dotfiles/app"

module Dotfiles
  class AppTest < Minitest::Test
    ROOT = File.expand_path("../..", __dir__)
    SYMLINK_ROOT = File.join(ROOT, "home_symlinks")

    class TestApp < App
      attr_reader :commands

      def initialize
        @commands = []
        super
      end

      private

      def action(*cmd)
        @commands << cmd
        puts "+ #{cmd.join(" ")}"

        case cmd.first
        when "mkdir", "mv", "ln"
          system(*cmd) || raise("command failed: #{cmd.join(" ")}")
        when "git"
          if cmd[1] == "clone" && cmd[2] == "https://github.com/tmux-plugins/tpm"
            FileUtils.mkdir_p(File.join(cmd[3], "bin"))
            File.write(File.join(cmd[3], "bin/install_plugins"), "#!/bin/sh\n")
          end
        when "curl"
          target = cmd[2]
          FileUtils.mkdir_p(File.dirname(target))
          File.write(target, "")
        end
      end
    end

    def test_run_installs_packages_links_dotfiles_and_installs_tools
      Dir.mktmpdir do |home|
        app = run_app_silently(home)

        assert_includes app.commands, ["brew", "bundle", "--file", File.join(ROOT, "Brewfile")]
        assert_includes app.commands, ["brew", "upgrade"]
        expected_links.each do |target, source|
          assert_symlink File.join(home, target), source
        end
        assert_includes app.commands, ["git", "clone", "https://github.com/tmux-plugins/tpm", File.join(home, ".tmux/plugins/tpm")]
        assert_includes app.commands, ["env", "HOME=#{home}", File.join(home, ".tmux/plugins/tpm/bin/install_plugins")]
        assert_includes app.commands, ["curl", "-fLo", File.join(home, ".vim/autoload/plug.vim"), "--create-dirs", "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"]
        assert_includes app.commands, ["vim", "-Nu", File.join(home, ".vimrc"), "-S", File.join(ROOT, "vim-plug-snapshot.vim"), "+qall"]
        assert_includes app.commands, ["mise", "install", "node@24"]
        assert_includes app.commands, ["mise", "use", "-g", "npm:@mariozechner/pi-coding-agent@latest"]
        assert_includes app.commands, ["mise", "reshim"]
      end
    end

    def test_linking_is_idempotent
      Dir.mktmpdir do |home|
        run_app_silently(home)
        run_app_silently(home)

        assert_symlink File.join(home, ".gitconfig"), File.join(SYMLINK_ROOT, ".gitconfig")
        assert_empty Dir.glob(File.join(home, ".gitconfig.backup.*"))
      end
    end

    def test_existing_file_is_backed_up_before_linking
      Dir.mktmpdir do |home|
        File.write(File.join(home, ".gitconfig"), "existing\n")

        run_app_silently(home)

        assert_symlink File.join(home, ".gitconfig"), File.join(SYMLINK_ROOT, ".gitconfig")
        backups = Dir.glob(File.join(home, ".gitconfig.backup.*"))
        assert_equal 1, backups.length
        assert_equal "existing\n", File.read(backups.first)
      end
    end

    def test_stale_managed_symlinks_are_reported_but_not_removed
      Dir.mktmpdir do |home|
        stale = File.join(home, ".config/ghostty/old")
        FileUtils.mkdir_p(File.dirname(stale))
        FileUtils.ln_s(File.join(SYMLINK_ROOT, ".config/ghostty/old"), stale)

        stdout, = capture_io { run_app(home) }

        assert_includes stdout, "warning: stale managed symlink: #{stale} -> #{File.join(SYMLINK_ROOT, ".config/ghostty/old")}"
        assert File.symlink?(stale), "expected stale symlink to be left in place"
      end
    end

    private

    def run_app_silently(home)
      app = nil
      capture_io { app = run_app(home) }
      app
    end

    def run_app(home)
      previous_home = ENV["DOTFILES_HOME"]
      ENV["DOTFILES_HOME"] = home
      app = TestApp.new
      app.run
      app
    ensure
      ENV["DOTFILES_HOME"] = previous_home
    end

    def expected_links
      Find.find(SYMLINK_ROOT).each_with_object({}) do |source, links|
        next if File.directory?(source)

        target = source.delete_prefix("#{SYMLINK_ROOT}/")
        links[target] = File.symlink?(source) ? File.readlink(source) : source
      end
    end

    def assert_symlink(target, expected_source)
      assert File.symlink?(target), "expected #{target} to be a symlink"
      assert_equal expected_source, File.readlink(target)
    end
  end
end
