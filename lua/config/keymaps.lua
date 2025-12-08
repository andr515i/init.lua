-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local set = vim.keymap.set
local del = vim.keymap.del
set("v", "<C-d>", "<C-d>zz", { desc = "move down half screen and center screen", noremap = true })

set("v", "<C-u>", "<C-u>zz", { desc = "move up half screen and center screen", noremap = true })

set("n", "n", "nzzzv", { desc = "move to next search result and center screen" })

set("n", "N", "Nzzzv", { desc = "move to previous search result and center screen" })

set("t", "<esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })

set("n", "<a-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })
-- visual mode: use the selection
-- set("v", "<A-s>", [[:s/\<<C-r>/<C-r>/gI<Left><Left><Left>]], { desc = "Substitute visual selection" })
set("x", "<a-s>", '"zy<Esc>:%s/<C-R>z/<C-R>z/gI<Left><Left><Left>')
-- Set location list with diagnostics
set(
    "n",
    "<leader>dq",
    "<cmd>lua vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR})<CR>",
    { noremap = true, silent = true }
)

-- Go to the next diagnostic
set("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })

-- Go to the previous diagnostic
set("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
-- quickfix navigation
set("n", "<C-n>", "<cmd>cnext<CR>", { desc = "next quickfix" })

set("n", "<C-p>", "<cmd>cprev<CR>", { desc = "previous quickfix" })

set({ "n", "t", "x", "v", "i" }, "¤", "$")

set("i", "<A-h>", "<home>", { noremap = true, silent = true })

set("i", "<A-l>", "<end>", { noremap = true, silent = true })

-- remove keymaps that are not needed
del("i", "<tab>")

-- change ; to : for faster command execution
set({ "n", "v" }, ";", ":", { noremap = true })

set(
    "v",
    "<leader>va",
    ":s/\\(.*\\)$/\\1\\r/<CR>",
    { noremap = true, silent = true, desc = "add linebreak at end of each highlighted line" }
)

-- set(
--     "n",
--     "<leader>qq",
--     vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR }),
--     { desc = "Set quickfix list with diagnostics" }
-- )
--

-- Auto-detect and run the *project* (cargo/dotnet/npm/ng/python/etc.)

-- Run the *current file* (e.g. python3 %)
set("n", "<leader>r", function()
    require("user.project_runner").run_current_file()
end, { desc = "Run current file", noremap = true, silent = true })

set("n", "æ", ":", { noremap = true })
set("n", "Æ", ":", { noremap = true })

-- change ; to : for faster command execution
set({ "n", "v" }, ";", ":", { noremap = true, silent = true })

-- find todo's
set("n", "<leader>sT", function()
    require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo/Fix/Fixme" })

-- multiline .
set("x", ".", ":normal .<CR>", { desc = "repeat last command in visual mode" })

set("n", "<c-d>", "22jzz", { desc = "move down 22 lines", noremap = true })
set("n", "<c-u>", "22kzz", { desc = "move up 22 lines", noremap = true })
-- Optional: a quick toggle if you ever want auto suggestions temporarily
set("n", "<M-d>", function()
    require("copilot.suggestion").toggle_auto_trigger()
end, { noremap = true, desc = "Copilot: toggle auto trigger" })
