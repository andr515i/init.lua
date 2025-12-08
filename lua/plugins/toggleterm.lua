return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    -- event = "VeryLazy",
    lazy = true,
    keys = {
        { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
}
