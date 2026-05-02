# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "tmpdir"

require_relative "../lib/dotfiles/app"

class DotfilesTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  LINKS = {
    ".gitconfig" => "home/.gitconfig",
    ".gitignore" => "home/.gitignore",
    ".zshrc" => "home/.zshrc",
    ".tmux.conf" => "home/.tmux.conf",
    ".tmux.mac.conf" => "home/.tmux.mac.conf",
    ".config/ghostty/config" => "home/.config/ghostty/config"
  }.freeze

  def test_dry_run_does_not_create_files
    Dir.mktmpdir do |home|
      capture_io { Dotfiles.new(["--home", home, "--dry-run", "link"]).run }

      refute File.exist?(File.join(home, ".gitconfig")), "dry-run created .gitconfig"
      refute File.exist?(File.join(home, ".config")), "dry-run created .config"
    end
  end

  def test_link_creates_expected_symlinks
    Dir.mktmpdir do |home|
      capture_io { Dotfiles.new(["--home", home, "link"]).run }

      LINKS.each do |target, source|
        assert_symlink File.join(home, target), File.join(ROOT, source)
      end
    end
  end

  def test_link_is_idempotent
    Dir.mktmpdir do |home|
      capture_io { Dotfiles.new(["--home", home, "link"]).run }
      capture_io { Dotfiles.new(["--home", home, "link"]).run }

      assert_symlink File.join(home, ".gitconfig"), File.join(ROOT, "home/.gitconfig")
      assert_empty Dir.glob(File.join(home, ".gitconfig.backup.*"))
    end
  end

  def test_existing_file_is_backed_up_before_linking
    Dir.mktmpdir do |home|
      File.write(File.join(home, ".gitconfig"), "existing\n")

      capture_io { Dotfiles.new(["--home", home, "link"]).run }

      assert_symlink File.join(home, ".gitconfig"), File.join(ROOT, "home/.gitconfig")
      backups = Dir.glob(File.join(home, ".gitconfig.backup.*"))
      assert_equal 1, backups.length
      assert_equal "existing\n", File.read(backups.first)
    end
  end

  private

  def assert_symlink(target, expected_source)
    assert File.symlink?(target), "expected #{target} to be a symlink"
    assert_equal expected_source, File.readlink(target)
  end
end
