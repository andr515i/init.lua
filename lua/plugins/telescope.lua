return {
    -- enable preview for telescope
    "nvim-telescope/telescope.nvim",
    require("telescope").setup({
        pickers = {
            colorscheme = {
                enable_preview = true,
            },
        },
    }),
}
