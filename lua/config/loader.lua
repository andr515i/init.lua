local M = {}

local ignored = {
  ["loader.lua"] = true,
  ["init.lua"] = true,
}

local function should_load(path)
  local name = vim.fn.fnamemodify(path, ":t")

  if ignored[name] then
    return false
  end

  if name:sub(1, 1) == "_" then
    return false
  end

  return name:sub(-4) == ".lua"
end

local function to_module(namespace, file)
  local config_root = vim.fn.stdpath("config") .. "/lua/" .. namespace:gsub("%.", "/") .. "/"
  local relative = file:sub(#config_root + 1)

  return namespace .. "." .. relative:gsub("%.lua$", ""):gsub("/", ".")
end

function M.load(namespace)
  local root = vim.fn.stdpath("config") .. "/lua/" .. namespace:gsub("%.", "/")

  local files = vim.fn.globpath(root, "**/*.lua", false, true)

  table.sort(files)

  for _, file in ipairs(files) do
    if should_load(file) then
      local mod = to_module(namespace, file)

      local ok, err = pcall(require, mod)

      if not ok then
        error(("Failed loading module '%s'\n\n%s"):format(mod, err))
      end
    end
  end
end

return M
