local map = vim.keymap.set

local function opts(desc, bufnr)
  return {
    buffer = bufnr,
    silent = true,
    desc = desc,
  }
end

local servers = {
  "lua_ls",
  "rust_analyzer",
  "clangd",
  "pyright",
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  "yamlls",
}

-- Global defaults for all LSP clients.
vim.lsp.config("*", {
  root_markers = { ".git" },
})

-- Lua / Neovim config.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim", "Snacks" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath("config"),
          vim.fn.stdpath("data") .. "/lazy",
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Rust.
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      check = {
        command = "clippy",
      },
      inlayHints = {
        enable = true,
      },
    },
  },
})

-- C / C++.
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--offset-encoding=utf-16",
  },
})

-- Python.
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- TypeScript / JavaScript.
vim.lsp.config("ts_ls", {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "literal",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "literal",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- LSP attach: buffer-local keymaps only when an LSP is active.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf

    map("n", "gd", vim.lsp.buf.definition, opts("Go to definition", bufnr))
    map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration", bufnr))
    map("n", "gr", vim.lsp.buf.references, opts("References", bufnr))
    map("n", "gI", vim.lsp.buf.implementation, opts("Go to implementation", bufnr))
    map("n", "gy", vim.lsp.buf.type_definition, opts("Go to type definition", bufnr))

    map("n", "K", vim.lsp.buf.hover, opts("Hover", bufnr))
    map("n", "<leader>ck", vim.lsp.buf.signature_help, opts("Signature help", bufnr))

    map("n", "<leader>cr", vim.lsp.buf.rename, opts("Rename", bufnr))
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action", bufnr))

    map("n", "<leader>cl", "<cmd>lsp log<CR>", opts("LSP log", bufnr))
    map("n", "<leader>ci", "<cmd>LspInfo<CR>", opts("LSP info", bufnr))
    map("n", "<leader>cR", "<cmd>lsp restart<CR>", opts("Restart LSP", bufnr))

    if vim.lsp.inlay_hint then
      map("n", "<leader>ch", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, opts("Toggle inlay hints", bufnr))
    end
  end,
})

vim.lsp.enable(servers)
