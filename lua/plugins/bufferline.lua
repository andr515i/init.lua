return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    options = {
      mode = "buffers",

      diagnostics = "nvim_lsp",

      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and "E" or "W"
        return " " .. icon .. ":" .. count
      end,

     numbers = "none",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,

      indicator = {
        style = "underline",
      },

      buffer_close_icon = "x",
      modified_icon = "+",
      close_icon = "x",
      left_trunc_marker = "<",
      right_trunc_marker = ">",
        custom_filter = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          local bt = vim.bo[bufnr].buftype
          local name = vim.api.nvim_buf_get_name(bufnr)

          if ft == "netrw" then
            return false
          end

          if bt == "nofile" and vim.fn.isdirectory(name) == 1 then
            return false
          end

          if vim.fn.isdirectory(name) == 1 then
            return false
          end

          return true
        end,      max_name_length = 24,
      max_prefix_length = 16,
      truncate_names = true,
      tab_size = 18,

      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          text_align = "center",
          separator = true,
        },
      },

      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true,

      separator_style = "thin",
      enforce_regular_tabs = false,
      always_show_bufferline = true,

      sort_by = "insert_after_current",
    },
  },

  keys = {
    -- Buffer navigation.
    {
      "<S-h>",
      "<cmd>BufferLineCyclePrev<CR>",
      desc = "Previous buffer",
    },
    {
      "<S-l>",
      "<cmd>BufferLineCycleNext<CR>",
      desc = "Next buffer",
    },

    -- Move buffers.
    {
      "<leader>bH",
      "<cmd>BufferLineMovePrev<CR>",
      desc = "Move buffer left",
    },
    {
      "<leader>bL",
      "<cmd>BufferLineMoveNext<CR>",
      desc = "Move buffer right",
    },

    -- Pick / pin.
    {
      "<leader>bp",
      "<cmd>BufferLineTogglePin<CR>",
      desc = "Pin buffer",
    },
    {
      "<leader>bb",
      "<cmd>BufferLinePick<CR>",
      desc = "Pick buffer",
    },

    -- Close buffers.
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete buffer",
    },
    {
      "<leader>bD",
      function()
        Snacks.bufdelete({ force = true })
      end,
      desc = "Force delete buffer",
    },
    {
      "<leader>bo",
      "<cmd>BufferLineCloseOthers<CR>",
      desc = "Delete other buffers",
    },
    {
      "<leader>bl",
      "<cmd>BufferLineCloseLeft<CR>",
      desc = "Delete buffers to left",
    },
    {
      "<leader>br",
      "<cmd>BufferLineCloseRight<CR>",
      desc = "Delete buffers to right",
    },
  },
}
