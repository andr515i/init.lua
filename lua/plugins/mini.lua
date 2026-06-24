return {
  "echasnovski/mini.nvim",
  version = false,
  event = "VeryLazy",

  config = function()
    require("mini.comment").setup({
      mappings = {
        comment = "gc",
        comment_line = "gcc",
        comment_visual = "gc",
        textobject = "gc",
      },
    })

    require("mini.surround").setup({
      mappings = {
        add = "sa",
        delete = "sd",
      },
    })

    require("mini.pairs").setup({
      modes = {
        insert = true,
        command = false,
        terminal = false,
      },
    })
  end,
}
