# frozen_string_literal: true

require "find"
require "fileutils"
require "optparse"
require "time"

module Dotfiles
  class App
    ROOT = File.expand_path("../..", __dir__)

    def initialize(argv)
      @home = ENV.fetch("DOTFILES_HOME", Dir.home)
      @dry_run = ENV["DOTFILES_DRY_RUN"] == "1"
      @verbose = ENV["DOTFILES_VERBOSE"] == "1"
      @non_interactive = ENV["DOTFILES_NON_INTERACTIVE"] == "1"
      @command = "install"

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: ./dotfiles [options] [command]\n\nCommands:\n  install  Link dotfiles and install managed tools (default)\n  link     Link dotfiles only\n  doctor   Check basic prerequisites\n  help     Show help"
        opts.on("--dry-run", "Do not execute commands that change the system") { @dry_run = true }
        opts.on("--verbose", "Print commands before executing them, or before skipping them in dry-run") { @verbose = true }
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
      when "install" then install
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
      say "+ #{cmd.join(" ")}" if @verbose
      system(*cmd) || raise("command failed: #{cmd.join(" ")}") unless @dry_run
    end

    def link_one(source, target)
      source = File.expand_path(source)
      target = File.expand_path(target)

      link_target = link_target_for(source)
      return if expected_link?(target, link_target)

      parent = File.dirname(target)
      action("mkdir", "-p", parent) unless Dir.exist?(parent)

      if File.exist?(target) || File.symlink?(target)
        backup = backup_path(target)
        action("mv", target, backup)
      end

      action("ln", "-s", link_target, target)
    end

    def link_target_for(source)
      File.symlink?(source) ? File.readlink(source) : source
    end

    def expected_link?(target, link_target)
      File.symlink?(target) && File.readlink(target) == link_target
    end

    def backup_path(path)
      "#{path}.backup.#{Time.now.strftime("%Y%m%d-%H%M%S")}"
    end

    def install
      link
      install_vim_plug
      install_npm_global_packages
    end

    def link
      say "Linking dotfiles..."

      symlink_root = File.join(ROOT, "home_symlinks")

      Find.find(symlink_root) do |source|
        next if File.directory?(source)

        target = File.join(@home, source.delete_prefix("#{symlink_root}/"))
        link_one(source, target)
      end

      warn_about_stale_managed_symlinks(symlink_root)
    end

    def install_vim_plug
      target = File.join(@home, ".vim/autoload/plug.vim")
      return if File.exist?(target)

      say "Installing vim-plug..."
      action(
        "curl",
        "-fLo",
        target,
        "--create-dirs",
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
      )
    end

    def install_npm_global_packages
      package_file = File.join(ROOT, "npm-global-packages.txt")
      return unless File.exist?(package_file)

      packages = File.readlines(package_file, chomp: true)
        .map(&:strip)
        .reject { it.empty? || it.start_with?("#") }
      return if packages.empty?

      say "Installing global npm packages..."
      action("mise", "install", "node@24")
      action("mise", "exec", "--", "npm", "install", "-g", *packages)
    end

    def warn_about_stale_managed_symlinks(symlink_root)
      stale_symlinks(symlink_root).each do |path|
        say "warning: stale managed symlink: #{path} -> #{File.readlink(path)}"
      end
    end

    def stale_symlinks(symlink_root)
      managed_targets(symlink_root).select do |path|
        File.symlink?(path) && symlink_target(path).start_with?("#{symlink_root}/") && !File.exist?(symlink_target(path))
      end
    end

    def managed_targets(symlink_root)
      Dir.children(symlink_root).flat_map do |entry|
        target = File.join(@home, entry)
        if File.directory?(File.join(symlink_root, entry)) && File.directory?(target)
          Find.find(target).to_a
        else
          [target]
        end
      end
    end

    def symlink_target(path)
      target = File.readlink(path)
      File.expand_path(target, File.dirname(path))
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
end
