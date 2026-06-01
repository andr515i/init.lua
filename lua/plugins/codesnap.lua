return {
    "mistricky/codesnap.nvim",
    version = "v2.0.0-beta.17",
    build = nil,
    config = function()
        require("codesnap").setup({
            show_workspace = false,
            snapshot_config = {
                watermark = nil,

                background = {
                    stops = {
                        {
                            position = 0,
                            color = "#00000000",
                        },
                        {
                            position = 1,
                            color = "#00000000",
                        },
                    },
                },

                window = {
                    margin = {
                        x = 0,
                        y = 0,
                    },
                },

                code_config = {
                    breadcrumbs = {
                        enable = false,
                    },
                },
            },
        })
    end,
}
