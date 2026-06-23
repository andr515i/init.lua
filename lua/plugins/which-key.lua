return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 500,
    spec = {
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>f", group = "find" },
          { "<leader>g", group = "git" },
          { "<leader>q", group = "quickfix" },
          { "<leader>s", group = "search" },
          { "<leader>r", group = "run" },
          { "<leader>x", group = "diagnostics" },
    },
  },
}
