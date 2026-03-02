-- Options are loaded before lazy.nvim startup
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Sync clipboard with system (works with macOS pbcopy/pbpaste)
vim.opt.clipboard = "unnamedplus"

-- Disable autoformat by default — run manually with <leader>cf
vim.g.autoformat = false

-- Use the system Ruby's neovim gem if available
-- Adjust path for rbenv or mise if needed
-- vim.g.ruby_host_prog = vim.fn.expand("~/.rbenv/shims/neovim-ruby-host")
