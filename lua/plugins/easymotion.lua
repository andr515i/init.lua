return {
    "easymotion/vim-easymotion",
    config = function()
        vim.g.easymotion_do_mapping =
            vim.keymap.set("n", "<leader>s", "<Plug>(easymotion-overwin-f2)", { desc = "Easymotion" })
        vim.keymap.set("n", "<leader>j", "<Plug>(easymotion-j)", { desc = "Easymotion Line" })
        vim.keymap.set("n", "<leader>k", "<Plug>(easymotion-k)", { desc = "Easymotion Line" })
    end,
}
