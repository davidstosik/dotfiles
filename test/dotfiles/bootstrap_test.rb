# frozen_string_literal: true

require "fileutils"
require "minitest/autorun"
require "open3"
require "tmpdir"

module Dotfiles
  class BootstrapTest < Minitest::Test
    ROOT = File.expand_path("../..", __dir__)
    FAKE_COMMAND = File.join(ROOT, "test/support/fake_command")

    def test_runs_brew_bundle_mise_and_dotfiles
      with_fake_commands(%w[uname brew mise ruby]) do |fake|
        result = run_bootstrap(fake, "link")

        assert_success result
        assert_includes fake.commands, ["brew", "bundle", "--file", File.join(ROOT, "Brewfile")]
        assert_includes fake.commands, ["mise", "trust", File.join(ROOT, ".mise.toml")]
        assert_includes fake.commands, ["mise", "install", "--cd", ROOT]
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles"), "link"]
      end
    end

    def test_skip_brew_bundle
      with_fake_commands(%w[uname brew mise ruby]) do |fake|
        result = run_bootstrap(fake, "--skip-brew-bundle", "link")

        assert_success result
        refute_includes fake.commands.map(&:first), "brew"
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles"), "link"]
      end
    end

    def test_non_interactive_mise_flags
      with_fake_commands(%w[uname brew mise ruby]) do |fake|
        result = run_bootstrap(fake, "--non-interactive", "link")

        assert_success result
        assert_includes fake.commands, ["mise", "trust", "-y", File.join(ROOT, ".mise.toml")]
        assert_includes fake.commands, ["mise", "install", "-y", "--cd", ROOT]
      end
    end

    def test_installs_mise_when_missing
      with_fake_commands(%w[uname brew ruby]) do |fake|
        result = run_bootstrap(fake, "--skip-brew-bundle", "link")

        assert_success result
        assert_includes fake.commands, ["brew", "install", "mise"]
        assert_includes fake.commands, ["mise", "exec", "--cd", ROOT, "--", "ruby", File.join(ROOT, "dotfiles"), "link"]
      end
    end

    private

    FakeSystem = Struct.new(:dir, :bin, :log) do
      def commands
        return [] unless File.exist?(log)

        File.readlines(log, chomp: true).map { |line| line.split("\t") }
      end
    end

    def with_fake_commands(commands)
      Dir.mktmpdir do |dir|
        fake = FakeSystem.new(dir, File.join(dir, "bin"), File.join(dir, "commands.log"))
        FileUtils.mkdir_p(fake.bin)
        FileUtils.cp(FAKE_COMMAND, File.join(fake.bin, "fake_command"))
        FileUtils.chmod("u+x", File.join(fake.bin, "fake_command"))
        commands.each { |command| FileUtils.ln_s(File.join(fake.bin, "fake_command"), File.join(fake.bin, command)) }
        yield fake
      end
    end

    def run_bootstrap(fake, *args)
      env = {
        "FAKE_COMMAND_BIN" => fake.bin,
        "FAKE_COMMAND_LOG" => fake.log,
        "PATH" => [fake.bin, "/usr/bin", "/bin", "/usr/sbin", "/sbin"].join(":"),
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
