-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*/kitty.conf",
    command = "silent !kill -SIGUSR1 $(pgrep -a kitty)",
})
vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
        vim.diagnostic.setqflist({
            severity = { "ERROR" },
            title = "Live LSP Errors",
            open = false, -- ← update only, don’t open
        })
    end,
})

-- keybinds to quickly start and stop language specific projects

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "rust" },
--     callback = function()
--         vim.keymap.set("n", "<leader>r", ":term cargo run<CR>", { noremap = true, silent = true })
--     end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "python" },
--     callback = function()
--         vim.keymap.set("n", "<leader>r", ":term python3 %<CR>", { noremap = true, silent = true })
--     end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "javascript" },
--     callback = function()
--         vim.keymap.set("n", "<leader>r", ":term node %<CR>", { noremap = true, silent = true })
--     end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "typescript" },
--     callback = function()
--         vim.keymap.set("n", "<leader>r", ":term ng serve<CR>", { noremap = true, silent = true })
--     end,
-- })
