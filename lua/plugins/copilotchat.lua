return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {
            {
                sticky = {
                    "@models Using Mistral-small",
                    "#files",
                },
            }, -- See Configuration section for options
        },
        keys = {
            { "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Open Copilot Chat" },
            { "<leader>zc", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain highlighted code " },
            { "<leader>zr", ":CopilotChatReview<CR>", mode = "v", desc = "Review highlighted code " },
            { "<leader>zo", ":CopilotChatOptimize<CR>", mode = "v", desc = "optimize highlighted  code" },
            { "<leader>zd", ":CopilotChatDocs<CR>", mode = "v", desc = "generate docs for highlighted code" },
            { "<leader>zm", "CopilotChatCommit<CR>", mode = "n", desc = "generate commit message" },
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
}
