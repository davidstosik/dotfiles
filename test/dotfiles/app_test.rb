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

    def test_dry_run_does_not_create_files
      Dir.mktmpdir do |home|
        stdout, = capture_io { App.new(["--home", home, "--dry-run", "link"]).run }

        assert_includes stdout, "Linking dotfiles..."
        refute_includes stdout, "+ ln -s"
        refute File.exist?(File.join(home, ".gitconfig")), "dry-run created .gitconfig"
        refute File.exist?(File.join(home, ".gitignore")), "dry-run created .gitignore"
        refute File.exist?(File.join(home, ".config")), "dry-run created .config"
      end
    end

    def test_dry_run_verbose_prints_commands_without_creating_files
      Dir.mktmpdir do |home|
        stdout, = capture_io { App.new(["--home", home, "--dry-run", "--verbose", "link"]).run }

        assert_includes stdout, "Linking dotfiles..."
        assert_includes stdout, "+ ln -s"
        refute File.exist?(File.join(home, ".gitconfig")), "dry-run created .gitconfig"
      end
    end

    def test_link_creates_expected_symlinks
      Dir.mktmpdir do |home|
        capture_io { App.new(["--home", home, "link"]).run }

        expected_links.each do |target, source|
          assert_symlink File.join(home, target), source
        end
      end
    end

    def test_link_is_idempotent
      Dir.mktmpdir do |home|
        capture_io { App.new(["--home", home, "link"]).run }
        capture_io { App.new(["--home", home, "link"]).run }

        assert_symlink File.join(home, ".gitconfig"), File.join(SYMLINK_ROOT, ".gitconfig")
        assert_empty Dir.glob(File.join(home, ".gitconfig.backup.*"))
      end
    end

    def test_existing_file_is_backed_up_before_linking
      Dir.mktmpdir do |home|
        File.write(File.join(home, ".gitconfig"), "existing\n")

        capture_io { App.new(["--home", home, "link"]).run }

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

        stdout, = capture_io { App.new(["--home", home, "link"]).run }

        assert_includes stdout, "warning: stale managed symlink: #{stale} -> #{File.join(SYMLINK_ROOT, ".config/ghostty/old")}" 
        assert File.symlink?(stale), "expected stale symlink to be left in place"
      end
    end

    def test_install_installs_global_npm_packages
      Dir.mktmpdir do |home|
        stdout, = capture_io { App.new(["--home", home, "--dry-run", "--verbose", "install"]).run }

        assert_includes stdout, "Installing vim-plug..."
        assert_includes stdout, "+ curl -fLo #{File.join(home, ".vim/autoload/plug.vim")} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        assert_includes stdout, "Installing global npm packages..."
        assert_includes stdout, "+ mise install node@24"
        assert_includes stdout, "+ mise exec -- npm install -g @mariozechner/pi-coding-agent"
      end
    end

    def test_link_does_not_install_global_npm_packages
      Dir.mktmpdir do |home|
        stdout, = capture_io { App.new(["--home", home, "--dry-run", "--verbose", "link"]).run }

        refute_includes stdout, "Installing global npm packages..."
        refute_includes stdout, "npm install"
      end
    end

    private

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
