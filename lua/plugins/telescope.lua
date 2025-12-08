return {
    -- enable preview for telescope
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    module = "telescope",
    require("telescope").setup({
        pickers = {
            colorscheme = {
                enable_preview = true,
            },
        },
    }),
}
