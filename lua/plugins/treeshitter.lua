local install_dir = vim.fn.stdpath("data") .. "/site"

local parsers = {
  -- Neovim/config
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "query",

  -- Shell/config/data
  "bash",
  "fish",
  "json",
  "toml",
  "yaml",
  "xml",

  -- Web / Angular
  "html",
  "css",
  "scss",
  "javascript",
  "typescript",
  "tsx",
  "angular",

  -- Systems / projects
  "c",
  "cpp",
  "cmake",
  "rust",
  "python",
  "c_sharp",

  -- Docs
  "markdown",
  "markdown_inline",

  -- Useful misc
  "diff",
  "dockerfile",
  "regex",
  "sql",
}

local function has_value(list, value)
  for _, item in ipairs(list) do
    if item == value then
      return true
    end
  end

  return false
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",

config = function()
  vim.opt.runtimepath:append(install_dir)

  local ts = require("nvim-treesitter")

  ts.setup({
    install_dir = install_dir,
  })

  ts.install(parsers)

  local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(event)
      local filetype = vim.bo[event.buf].filetype
      local lang = vim.treesitter.language.get_lang(filetype)

      if not lang then
        return
      end

      if not vim.tbl_contains(parsers, lang) then
        return
      end

      pcall(vim.treesitter.start, event.buf, lang)
    end,
  })
end,}
