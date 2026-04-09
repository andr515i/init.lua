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

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust" },
    callback = function()
        vim.lsp.inlay_hint.enable(false)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    command = "setlocal nospell",
})
-- i dont use this, because i know how to save my files.
-- local group = vim.api.nvim_create_augroup("AutoFormatAndSave", { clear = true })
--
-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
--     group = group,
--     callback = function(args)
--         local buf = args.buf
--
--         -- Skip unwanted buffer types (neo-tree, help, terminals, etc.)
--         if vim.bo[buf].buftype ~= "" then
--             return
--         end
--
--         -- Skip unnamed buffers
--         if vim.api.nvim_buf_get_name(buf) == "" then
--             return
--         end
--
--         -- Skip not modifiable or readonly
--         if vim.bo[buf].readonly or not vim.bo[buf].modifiable then
--             return
--         end
--
--         -- Skip if nothing changed
--         if not vim.bo[buf].modified then
--             return
--         end
--
--         -- Run LazyVim's formatter (Conform)
--         -- Silent async call
--         vim.cmd("silent! LazyFormat")
--
--         -- Save buffer
--
--         vim.cmd("silent! write")
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
