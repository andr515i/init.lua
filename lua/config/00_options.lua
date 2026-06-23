vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = true
opt.breakindent = true
opt.textwidth = 0

opt.scrolloff = 18
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.updatetime = 250
opt.timeoutlen = 500

opt.clipboard = "unnamedplus"

opt.completeopt = { "menu", "menuone", "noselect" }

opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

opt.fillchars = {
  eob = " ",
}

vim.cmd.colorscheme("habamax")
