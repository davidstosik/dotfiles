# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "open3"
require "tmpdir"

module Dotfiles
  class BootstrapTest < Minitest::Test
    ROOT = File.expand_path("../..", __dir__)
    FAKE_BIN = File.join(ROOT, "test/support/fake_bin")

    def test_runs_brew_bundle_mise_and_dotfiles
      with_fake_system do |fake|
        result = run_bootstrap(fake, "link")

        assert_success result
        assert_includes fake.commands, ["brew", "bundle", "--file", File.join(ROOT, "Brewfile")]
        assert_includes fake.commands, ["mise", "trust", File.join(ROOT, ".mise.toml")]
        assert_includes fake.commands, ["mise", "install", "--cd", ROOT]
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles"), "link"]
      end
    end

    def test_skip_brew_bundle
      with_fake_system do |fake|
        result = run_bootstrap(fake, "--skip-brew-bundle", "link")

        assert_success result
        refute_includes fake.commands.map(&:first), "brew"
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
        fake.create_executables("brew", "mise")

        result = run_bootstrap(fake, "--skip-brew-bundle", "link")

        assert_success result
        assert_includes fake.commands, ["brew", "install", "mise"]
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles"), "link"]
      end
    end

    def test_dry_run_continues_past_missing_mise
      with_fake_system(missing: %w[mise]) do |fake|
        result = run_bootstrap(fake, "--dry-run", "--skip-brew-bundle", "--verbose", "link")

        assert_success result
        assert_includes fake.commands, ["ruby", File.join(ROOT, "dotfiles"), "link"]
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
      env = {
        "FAKE_COMMAND_BEHAVIOR_DIR" => fake.behavior_dir,
        "FAKE_COMMAND_BIN" => fake.bin,
        "FAKE_COMMAND_LOG" => fake.log,
        "PATH" => fake.path,
      }
      stdout, stderr, status = Open3.capture3(env, File.join(ROOT, "bootstrap"), *args, chdir: ROOT)
      { stdout: stdout, stderr: stderr, status: status }
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
