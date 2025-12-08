return {
    "neovim/nvim-lspconfig",
    ft = { "rust", "python", "cs", "cpp", "lua", "typescript", "markdown", "java" },
    event = "BufReadPre", -- only when a real file is opened
    opts = {
        inlay_hints = { enabled = false },
        setup = {
            rust_analyzer = function()
                return true
            end,
        },
    },
}
