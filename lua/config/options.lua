-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 12

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- vim.opt.linebreak = true
vim.opt.breakindent = true
vim.wo.wrap = true

vim.diagnostic.config({
    text = { severity = { min = vim.diagnostic.severity.ERROR } },
    signs = { severity = { min = vim.diagnostic.severity.ERROR } },
    underline = { severity = { min = vim.diagnostic.severity.ERROR } },
})

vim.g.rustaceanvim = {
    server = {
        cmd = function()
            local mason_registry = require("mason-registry")
            if mason_registry.is_installed("rust-analyzer") then
                -- This may need to be tweaked depending on the operating system.
                local ra = mason_registry.get_package("rust-analyzer")
                local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
                return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
            else
                -- global installation
                return { "rust-analyzer" }
            end
        end,
    },
}

--disable mouse
-- vim.opt.mouse = ""
