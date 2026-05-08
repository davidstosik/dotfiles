# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "open3"
require "tmpdir"

module Dotfiles
  class BootstrapTest < Minitest::Test
    ROOT = File.expand_path("../..", __dir__)
    FAKE_BIN = File.join(ROOT, "test/support/fake_bin")

    def test_runs_canonical_bootstrap_flow
      with_fake_system do |fake|
        fake.stdout("git", "#{ROOT}\n")
        result = run_bootstrap(fake)

        assert_success result
        assert_includes fake.commands, ["sudo", "-v"]
        assert_includes fake.commands, ["brew", "update"]
        assert_includes fake.commands, ["brew", "install", "git", "mise"]
        assert_includes fake.commands, ["mise", "trust", "-y", File.join(ROOT, ".mise.toml")]
        assert_includes fake.commands, ["mise", "install", "-y", "--cd", ROOT]
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles")]
      end
    end

    def test_bootstrap_script_clones_repository_before_continuing
      skip "git is required" unless system("command -v git >/dev/null 2>&1")

      with_fake_system do |fake|
        repo = create_install_test_repo(fake.dir)
        install_dir = File.join(fake.dir, "home/.dotfiles")
        result = run_remote_clone_bootstrap(fake, repo)

        assert_success result
        assert_path_exists File.join(install_dir, ".git")
        assert_includes fake.commands, ["mise", "exec", "--cd", install_dir, "--", "ruby", File.join(install_dir, "dotfiles")]
      end
    end

    private

    FakeSystem = Struct.new(:dir, :bin, :log, :behavior_dir) do
      def commands
        return [] unless File.exist?(log)

        File.readlines(log, chomp: true).map { |line| line.split("\t") }
      end

      def stdout(command, content)
        write_behavior(command, "stdout", content)
      end

      def path
        [bin, "/usr/bin", "/bin", "/usr/sbin", "/sbin"].join(":")
      end

      private

      def write_behavior(command, file, content)
        command_dir = File.join(behavior_dir, command)
        FileUtils.mkdir_p(command_dir)
        File.write(File.join(command_dir, file), content)
      end
    end

    def with_fake_system
      Dir.mktmpdir do |dir|
        fake = FakeSystem.new(
          dir,
          FAKE_BIN,
          File.join(dir, "commands.log"),
          File.join(dir, "behavior")
        )
        fake.stdout("uname", "Darwin\n")
        yield fake
      end
    end

    def run_bootstrap(fake)
      env = fake_env(fake)
      bootstrap = File.join(ROOT, "bootstrap")
      stdout, stderr, status = Open3.capture3(env, [bootstrap, bootstrap], chdir: ROOT)
      { stdout: stdout, stderr: stderr, status: status }
    end

    def create_install_test_repo(dir)
      repo = File.join(dir, "repo")
      FileUtils.mkdir_p(File.join(repo, "lib"))
      %w[bootstrap dotfiles Brewfile .mise.toml mise-global-tools.txt vim-plug-snapshot.vim].each do |path|
        FileUtils.cp(File.join(ROOT, path), File.join(repo, path))
      end
      FileUtils.cp_r(File.join(ROOT, "lib/dotfiles"), File.join(repo, "lib/dotfiles"))
      FileUtils.cp_r(File.join(ROOT, "home_symlinks"), File.join(repo, "home_symlinks"))

      system("git", "init", repo, out: File::NULL, err: File::NULL) || raise("git init failed")
      system("git", "-C", repo, "checkout", "-B", "main", out: File::NULL, err: File::NULL) || raise("git checkout failed")
      system("git", "-C", repo, "add", ".", out: File::NULL, err: File::NULL) || raise("git add failed")
      system("git", "-C", repo, "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-m", "initial", out: File::NULL, err: File::NULL) || raise("git commit failed")
      repo
    end

    def run_remote_clone_bootstrap(fake, repo)
      remote_dir = File.join(fake.dir, "remote-clone")
      FileUtils.mkdir_p(remote_dir)
      remote_bootstrap = File.join(remote_dir, "bootstrap")
      FileUtils.cp(File.join(ROOT, "bootstrap"), remote_bootstrap)
      FileUtils.chmod("u+x", remote_bootstrap)

      env = fake_env(fake).merge(
        "DOTFILES_REPO_URL" => repo,
        "DOTFILES_REPO_REF" => "main",
        "HOME" => File.join(fake.dir, "home"),
        "PATH" => path_with_real_git(fake)
      )
      stdout, stderr, status = Open3.capture3(env, [remote_bootstrap, remote_bootstrap], chdir: fake.dir)
      { stdout: stdout, stderr: stderr, status: status }
    end

    def fake_env(fake)
      {
        "FAKE_COMMAND_BEHAVIOR_DIR" => fake.behavior_dir,
        "FAKE_COMMAND_BIN" => fake.bin,
        "FAKE_COMMAND_LOG" => fake.log,
        "PATH" => fake.path,
      }
    end

    def path_with_real_git(fake)
      bin = File.join(fake.dir, "fake_bin_without_git")
      FileUtils.cp_r(FAKE_BIN, bin, preserve: true)
      FileUtils.rm_f(File.join(bin, "git"))
      [bin, "/usr/bin", "/bin", "/usr/sbin", "/sbin"].join(":")
    end

    def assert_success(result)
      assert result[:status].success?, <<~MESSAGE
        expected bootstrap to succeed
        stdout: #{result[:stdout]}
        stderr: #{result[:stderr]}
      MESSAGE
    end
  end
end
