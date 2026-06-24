return {
  {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  event = "InsertEnter",

  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local luasnip = require("luasnip")

    luasnip.config.setup({
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    })

    -- Big community snippet library.
    -- This is what LazyVim's LuaSnip extra uses.
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Optional VSCode-style personal snippets:
    -- ~/.config/nvim/snippets/*.json
    -- Windows: ~/AppData/Local/nvim/snippets/*.json
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = {
        vim.fn.stdpath("config") .. "/snippets",
      },
    })

    -- Our existing LuaSnip-native personal snippets:
    -- ~/.config/nvim/lua/snippets/*.lua
    -- Windows: ~/AppData/Local/nvim/lua/snippets/*.lua
    require("luasnip.loaders.from_lua").lazy_load({
      paths = {
        vim.fn.stdpath("config") .. "/lua/snippets",
      },
    })
  end,
},
  { "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },

    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
opts = {
  snippets = {
    preset = "luasnip",
  },

  keymap = {
    preset = "enter",

    -- Keep explicit accept too.
    ["<C-y>"] = { "select_and_accept" },

    -- LazyVim-ish feel:
    -- - if completion menu is open: Tab moves down
    -- - if inside a snippet: Tab jumps forward
    -- - otherwise: literal Tab / fallback
    ["<Tab>"] = {
      "select_next",
      "snippet_forward",
      "fallback",
    },

    ["<S-Tab>"] = {
      "select_prev",
      "snippet_backward",
      "fallback",
    },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
  },

  signature = {
    enabled = true,
  },

  sources = {
    default = {
      "snippets",
      "lsp",
      "path",
      "buffer",
    },

    providers = {
      -- Source order alone does not guarantee visual priority.
      -- score_offset does.
      snippets = {
        score_offset = 100,
      },
      lsp = {
        score_offset = 0,
      },
      path = {
        score_offset = -10,
      },
      buffer = {
        score_offset = -20,
      },
    },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
},
    opts_extend = {
      "sources.default",
    },
  },
}
