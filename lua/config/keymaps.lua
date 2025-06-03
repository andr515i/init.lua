-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("v", "<C-d>", "<C-d>zz", { desc = "move down half screen and center screen", noremap = true })

vim.keymap.set("v", "<C-u>", "<C-u>zz", { desc = "move up half screen and center screen", noremap = true })

vim.keymap.set("n", "n", "nzzzv", { desc = "move to next search result and center screen" })

vim.keymap.set("n", "N", "Nzzzv", { desc = "move to previous search result and center screen" })

vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "exit terminal mode" })

vim.keymap.set(
    "n",
    "<a-s>",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Substitute word under cursor" }
)

vim.keymap.set("n", "<leader>bt", "<cmd>botright terminal<CR>a", { desc = "open terminal in botright position" })

-- Set location list with diagnostics
vim.keymap.set(
    "n",
    "<leader>dq",
    "<cmd>lua vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR})<CR>",
    { noremap = true, silent = true }
)

-- Go to the next diagnostic
vim.keymap.set("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })

-- Go to the previous diagnostic
vim.keymap.set("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
-- quickfix navigation
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>", { desc = "next quickfix" })

vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>", { desc = "previous quickfix" })

-- Key mappings for Alt+1 to Alt+9 to switch to buffers 1-9
for i = 1, 9 do
    vim.keymap.set(
        { "n", "t", "x", "v", "i" },
        "<A-" .. i .. ">",
        "<cmd>BufferLineGoToBuffer " .. i .. "<CR>",
        { noremap = true, silent = true }
    )
end

vim.keymap.set({ "n", "t", "x", "v", "i" }, "¤", "$")

-- vim.keymap.set({"n", "t", "x", "v", "i"}, "", "", { desc = "" })

vim.keymap.set({ "n" }, "<C-c>", "ciw")

vim.keymap.set("i", "<A-h>", "<home>", { noremap = true, silent = true })

vim.keymap.set("i", "<A-l>", "<end>", { noremap = true, silent = true })

vim.keymap.set("i", "<A-w>", "<C-o>dw", { noremap = true, silent = true })

-- paste without overwriting the default register
vim.keymap.set(
    "n",
    "<leader>P",
    '"_dP',
    { noremap = true, silent = true, desc = "paste without overwriting default register" }
)

-- remove keymaps that are not needed
vim.keymap.del("i", "<tab>")

-- change ; to : for faster command execution
vim.keymap.set({ "n", "v" }, ";", ":", { noremap = true })

vim.keymap.set(
    "v",
    "<leader>va",
    ":s/\\(.*\\)$/\\1\\r/<CR>",
    { noremap = true, silent = true, desc = "add linebreak at end of each highlighted line" }
)

-- vim.keymap.set(
--     "n",
--     "<leader>qq",
--     vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR }),
--     { desc = "Set quickfix list with diagnostics" }
-- )
--

vim.keymap.set("n", "<leader>r", function()
    require("user.rust_runner").run()
end, { desc = "Run cargo run and restore foxu on exit", noremap = true, silent = true })
