return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = {
    preset = "modern",
    delay = 500,

    spec = {
      { "<leader>b", group = "buffers" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>n", group = "notifications/messages" },
      { "<leader>q", group = "quickfix" },
      { "<leader>r", group = "run" },
      { "<leader>s", group = "search" },
      { "<leader>x", group = "diagnostics" },
    },
  },
}
