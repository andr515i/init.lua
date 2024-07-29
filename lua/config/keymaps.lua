-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Set leader key
vim.g.mapleader = " "

-- Key mappings
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Ex mode" })

vim.keymap.set("x", "<leader>p", '"_dp', { desc = "Paste without yanking" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>p", '"_dp', { desc = "Paste without yanking" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to clipboard" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete selection without yanking" })

vim.keymap.set(
  "n",
  "<leader>sw",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute word under cursor" }
)

vim.keymap.set("i", "(", "()<left>", { desc = "Insert () and move left" })
vim.keymap.set("i", '"', '""<left>', { desc = 'Insert "" and move left' })
vim.keymap.set("i", "{", "{}<left>", { desc = "Insert {} and move left" })
vim.keymap.set("i", "[", "[]<left>", { desc = "Insert [] and move left" })
vim.keymap.set(
  "i",
  "{<CR>",
  "{}<Left><CR><Esc>:LspZeroFormat<CR>kA<CR>",
  { desc = "Insert {} with newline and format" }
)

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set({ "n", "v" }, "<leader>s", vim.cmd.write, { desc = "Save file" })

-- which-key shenanigans
local wk = require("which-key")

wk.add({
  { "<leader>pv", vim.cmd.Ex },
  { "<leader>p", '"_dp' },
  { "<leader>y", '"+y' },
  { "<A-j>", ":m '>+1<CR>gv=gv" },
  { "<A-k>", ":m '<-2<CR>gv=gv" },
  { "J", "mzJ`z" },
  { "<C-d>", "<C-d>zz" },
  { "<C-u>", "<C-u>zz" },
  { "n", "nzzzv" },
  { "N", "Nzzzv" },
  { "<leader>d", '"_d' },
  { "q", "<nop>" },
  { "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]] },
  { "(", "()<left>" },
  { '"', '""<left>' },
  { "{", "{}<left>" },
  { "[", "[]<left>" },
  { "{<CR>", "{}<Left><CR><Esc>:LspZeroFormat<CR>kA<CR>" },
  { "<Esc><Esc>", "<C-\\><C-n>" },
  { "<leader>s", vim.cmd.write },
  { "<leader>p", '"_dp' },
  { "<leader>y", '"+y' },
  { "<A-j>", ":m '>+1<CR>gv=gv" },
  { "<A-k>", ":m '<-2<CR>gv=gv" },
  { "<leader>d", '"_d' },
  { "<Esc><Esc>", "<C-\\><C-n>" },
  { "<leader>s", vim.cmd.write },
})
