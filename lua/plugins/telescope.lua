return {
    -- enable preview for telescope
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = {
        pickers = {
            colorscheme = {
                enable_preview = true,
            },
        },
    },
}
