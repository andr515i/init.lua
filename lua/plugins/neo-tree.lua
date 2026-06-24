return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  cmd = "Neotree",
init = function()
  -- LazyVim-style fix:
  -- Load Neo-tree early when Neovim was started with a directory.
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
    desc = "Start Neo-tree when opening a directory",
    once = true,
    callback = function()
      if package.loaded["neo-tree"] then
        return
      end

      local arg = vim.fn.argv(0)
      if arg == nil or arg == "" then
        return
      end

      local path = vim.fn.fnamemodify(arg, ":p")
      local stat = vim.uv.fs_stat(path)

      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end,
  })
end,
  keys = {
    {
      "<leader>e",
      "<cmd>Neotree toggle filesystem reveal left<CR>",
      desc = "Toggle explorer",
    },
  },

  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,

    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
      },

      git_status = {
        symbols = {
          added = "A",
          modified = "M",
          deleted = "D",
          renamed = "R",
          untracked = "?",
          ignored = "!",
          unstaged = "U",
          staged = "S",
          conflict = "C",
        },
      },
    },

    window = {
      position = "left",
      width = 34,

      mappings = {
        ["<space>"] = "none",

        ["l"] = "open",
        ["h"] = "close_node",

        ["<CR>"] = "open",
        ["o"] = "open",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["t"] = "open_tabnew",

        ["a"] = {
          "add",
          config = {
            show_path = "relative",
          },
        },
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["c"] = "copy",
        ["m"] = "move",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",

        ["R"] = "refresh",
        ["?"] = "show_help",
        ["q"] = "close_window",
      },
    },

    filesystem = {
        bind_to_cwd = false,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },

      use_libuv_file_watcher = true,

      hijack_netrw_behavior = "open_current",

      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,


          ".git",
          "node_modules",
          "__pycache__",
          ".venv",
          "target",
          "build",
          "dist",
        },

        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
    },

    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
    },

    source_selector = {
      winbar = false,
      statusline = false,
    },
  }
