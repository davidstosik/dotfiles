# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "open3"
require "tmpdir"

module Dotfiles
  class BootstrapTest < Minitest::Test
    ROOT = File.expand_path("../..", __dir__)
    FAKE_BIN = File.join(ROOT, "test/support/fake_bin")

    def test_runs_homebrew_mise_and_dotfiles
      with_fake_system do |fake|
        result = run_bootstrap(fake, "link")

        assert_success result
        assert_includes fake.commands, ["brew", "update"]
        assert_includes fake.commands, ["brew", "bundle", "--file", File.join(ROOT, "Brewfile")]
        assert_includes fake.commands, ["brew", "upgrade"]
        assert_includes fake.commands, ["mise", "trust", File.join(ROOT, ".mise.toml")]
        assert_includes fake.commands, ["mise", "install", "--cd", ROOT]
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles"), "link"]
      end
    end

    def test_defaults_to_install_command
      with_fake_system do |fake|
        result = run_bootstrap(fake)

        assert_success result
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles")]
      end
    end

    def test_skip_brew_bundle
      with_fake_system do |fake|
        result = run_bootstrap(fake, "--skip-brew-bundle", "link")

        assert_success result
        assert_includes fake.commands, ["brew", "update"]
        refute_includes fake.commands, ["brew", "bundle", "--file", File.join(ROOT, "Brewfile")]
        refute_includes fake.commands, ["brew", "upgrade"]
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles"), "link"]
      end
    end

    def test_non_interactive_mise_flags
      with_fake_system do |fake|
        result = run_bootstrap(fake, "--non-interactive", "link")

        assert_success result
        assert_includes fake.commands, ["mise", "trust", "-y", File.join(ROOT, ".mise.toml")]
        assert_includes fake.commands, ["mise", "install", "-y", "--cd", ROOT]
      end
    end

    def test_installs_mise_when_missing
      with_fake_system(missing: %w[mise]) do |fake|
        fake.create_executables_when("brew", %w[install mise], "mise")

        result = run_bootstrap(fake, "--skip-brew-bundle", "link")

        assert_success result
        assert_includes fake.commands, ["brew", "install", "mise"]
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles"), "link"]
      end
    end

    def test_bootstrap_script_clones_repository_before_continuing
      skip "git is required" unless system("command -v git >/dev/null 2>&1")

      with_fake_system do |fake|
        repo = create_install_test_repo(fake.dir)
        install_dir = File.join(fake.dir, "cloned-dotfiles")
        result = run_remote_clone_install(fake, repo, install_dir, "--skip-brew-bundle", "link")

        assert_success result
        assert_path_exists File.join(install_dir, ".git")
        assert_includes fake.commands, ["mise", "exec", "--cd", install_dir, "--", "ruby", File.join(install_dir, "dotfiles"), "link"]
      end
    end

    def test_dry_run_continues_past_missing_mise
      with_fake_system(missing: %w[mise]) do |fake|
        result = run_bootstrap(fake, "--dry-run", "--skip-brew-bundle", "--verbose", "link")

        assert_success result
        refute_includes fake.commands.map(&:first), "ruby"
        assert_includes result[:stdout], "+ brew install mise"
        assert_includes result[:stdout], "+ mise install --cd #{ROOT}"
        assert_includes result[:stdout], "+ mise exec --cd #{ROOT} -- ruby #{File.join(ROOT, "dotfiles")} link"
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

      def status(command, code)
        write_behavior(command, "status", "#{code}\n")
      end

      def create_executables(command, *executables)
        write_behavior(command, "create_executables", "#{executables.join("\n")}\n")
      end

      def create_executables_when(command, args, *executables)
        lines = executables.map { "#{args.join(" ")}\t#{it}" }.join("\n")
        write_behavior(command, "create_executables_when", "#{lines}\n")
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

    def with_fake_system(missing: [])
      Dir.mktmpdir do |dir|
        fake = FakeSystem.new(
          dir,
          fake_bin(missing: missing, tmpdir: dir),
          File.join(dir, "commands.log"),
          File.join(dir, "behavior")
        )
        fake.stdout("uname", "Darwin\n")
        assert_missing_commands_are_not_in_path(fake, missing)
        yield fake
      end
    end

    def fake_bin(missing:, tmpdir:)
      return FAKE_BIN if missing.empty?

      destination = File.join(tmpdir, "fake_bin")
      FileUtils.cp_r(FAKE_BIN, destination, preserve: true)
      missing.each { FileUtils.rm_f(File.join(destination, it)) }
      destination
    end

    def assert_missing_commands_are_not_in_path(fake, missing)
      missing.each do |command|
        refute system({ "PATH" => fake.path }, "command -v #{command} >/dev/null 2>&1"),
          "expected #{command.inspect} to be missing from test PATH"
      end
    end

    def run_bootstrap(fake, *args)
      env = fake_env(fake)
      bootstrap = File.join(ROOT, "bootstrap")
      stdout, stderr, status = Open3.capture3(env, [bootstrap, bootstrap], *args, chdir: ROOT)
      { stdout: stdout, stderr: stderr, status: status }
    end

    def create_install_test_repo(dir)
      repo = File.join(dir, "repo")
      FileUtils.mkdir_p(File.join(repo, "lib"))
      %w[bootstrap dotfiles Brewfile .mise.toml].each do |path|
        FileUtils.cp(File.join(ROOT, path), File.join(repo, path))
      end
      FileUtils.cp_r(File.join(ROOT, "lib/dotfiles"), File.join(repo, "lib/dotfiles"))

      system("git", "init", repo, out: File::NULL, err: File::NULL) || raise("git init failed")
      system("git", "-C", repo, "checkout", "-B", "main", out: File::NULL, err: File::NULL) || raise("git checkout failed")
      system("git", "-C", repo, "add", ".", out: File::NULL, err: File::NULL) || raise("git add failed")
      system("git", "-C", repo, "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-m", "initial", out: File::NULL, err: File::NULL) || raise("git commit failed")
      repo
    end

    def run_remote_clone_install(fake, repo, install_dir, *args)
      remote_dir = File.join(fake.dir, "remote-clone")
      FileUtils.mkdir_p(remote_dir)
      remote_bootstrap = File.join(remote_dir, "bootstrap")
      FileUtils.cp(File.join(ROOT, "bootstrap"), remote_bootstrap)
      FileUtils.chmod("u+x", remote_bootstrap)

      env = fake_env(fake).merge(
        "DOTFILES_INSTALL_DIR" => install_dir,
        "DOTFILES_REPO_URL" => repo,
        "DOTFILES_REPO_REF" => "main",
        "HOME" => File.join(fake.dir, "home"),
        "PATH" => path_with_real_git(fake)
      )
      stdout, stderr, status = Open3.capture3(env, [remote_bootstrap, remote_bootstrap], *args, chdir: fake.dir)
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
