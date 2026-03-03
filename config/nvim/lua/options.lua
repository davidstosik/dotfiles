-- Options

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.gdefault = true  -- Substitute globally by default

-- Display
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "81"
opt.showmode = false    -- Shown by lualine instead
opt.wrap = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", extends = ">", precedes = "<", nbsp = "%" }

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Files
opt.undofile = true
opt.backup = false
opt.swapfile = false
opt.autoread = true

-- Clipboard (sync with system)
opt.clipboard = "unnamedplus"

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- Misc
opt.updatetime = 250
opt.timeoutlen = 300
opt.mouse = "a"
opt.wildmode = { "list", "longest" }

-- Leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable netrw (we use telescope and oil.nvim)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
