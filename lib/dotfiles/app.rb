# frozen_string_literal: true

require "find"
require "fileutils"
require "optparse"
require "time"

class Dotfiles
  ROOT = File.expand_path("../..", __dir__)

  def initialize(argv)
    @home = ENV.fetch("DOTFILES_HOME", Dir.home)
    @dry_run = ENV["DOTFILES_DRY_RUN"] == "1"
    @non_interactive = ENV["DOTFILES_NON_INTERACTIVE"] == "1"
    @command = "link"

    parser = OptionParser.new do |opts|
      opts.banner = "Usage: ./dotfiles [options] [command]"
      opts.on("--dry-run", "Print actions without changing files") { @dry_run = true }
      opts.on("--non-interactive", "Never prompt") { @non_interactive = true }
      opts.on("--home PATH", "Use PATH instead of HOME") { |path| @home = path }
      opts.on("-h", "--help", "Show help") { @command = "help" }
    end

    rest = parser.parse(argv)
    @command = rest.first if rest.first
    @parser = parser
  end

  def run
    case @command
    when "link" then link
    when "doctor" then doctor
    when "help" then puts @parser
    else
      warn "Unknown command: #{@command}"
      puts @parser
      exit 2
    end
  end

  private

  def say(message)
    puts message
  end

  def action(*cmd)
    if @dry_run
      say "DRY-RUN: #{cmd.join(" ")}"
    else
      system(*cmd) || raise("command failed: #{cmd.join(" ")}")
    end
  end

  def link_one(source, target)
    source = File.expand_path(source)
    target = File.expand_path(target)

    if expected_link?(target, source)
      say "ok: #{target} -> #{source}"
      return
    end

    parent = File.dirname(target)
    action("mkdir", "-p", parent) unless Dir.exist?(parent)

    if File.exist?(target) || File.symlink?(target)
      backup = backup_path(target)
      say "backup: #{target} -> #{backup}"
      action("mv", target, backup)
    end

    say "link: #{target} -> #{source}"
    action("ln", "-s", source, target)
  end

  def expected_link?(target, source)
    File.symlink?(target) && File.readlink(target) == source
  end

  def backup_path(path)
    "#{path}.backup.#{Time.now.strftime("%Y%m%d-%H%M%S")}"
  end

  def link
    symlink_root = File.join(ROOT, "home_symlinks")

    Find.find(symlink_root) do |source|
      next if File.directory?(source)

      target = File.join(@home, source.delete_prefix("#{symlink_root}/"))
      link_one(source, target)
    end
  end

  def doctor
    missing = %w[git ruby].reject { |cmd| system("command -v #{cmd}", out: File::NULL, err: File::NULL) }
    if missing.empty?
      say "doctor: ok"
    else
      missing.each { |cmd| warn "missing: #{cmd}" }
      exit 1
    end
  end
end
