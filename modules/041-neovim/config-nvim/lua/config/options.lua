-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.ruby_host_prog = "neovim-ruby-host"
vim.opt.clipboard = vim.env.SSH_TTY and "unnamedplus" or "unnamedplus" -- Sync with system clipboard -- FIXME only for spin?
vim.g.autoformat = false
