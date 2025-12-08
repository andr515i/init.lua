-- ~/.config/nvim/lua/user/project_runner.lua
local api = vim.api
local fn = vim.fn
local fs = vim.fs
local uv = vim.uv or vim.loop
local Terminal = require("toggleterm.terminal").Terminal

local M = {}

local terms = {} -- cache per (root::kind)
local prev_win = nil -- remember window to restore focus

-- --- helpers ---------------------------------------------------------
local function buf_dir()
    local name = api.nvim_buf_get_name(0)
    if name == "" then
        return uv.cwd()
    end
    return fs.dirname(name)
end

local function find_root()
    local dir = buf_dir()
    local git = fs.find(".git", { path = dir, upward = true, type = "directory" })[1]
    if git then
        return fs.dirname(git)
    end
    local markers = { "Cargo.toml", "package.json", "pyproject.toml", ".venv", ".git" }
    local found = fs.find(markers, { path = dir, upward = true })[1]
    if found then
        return fs.dirname(found)
    end
    return uv.cwd()
end

local function exists(p)
    return uv.fs_stat(p) ~= nil
end

local function read_json(path)
    local ok, data = pcall(fn.readfile, path)
    if not ok or not data or #data == 0 then
        return nil
    end
    local ok2, obj = pcall(vim.json.decode, table.concat(data, "\n"))
    return ok2 and obj or nil
end

-- --- detectors (project) ---------------------------------------------
local function detect_rust(root)
    if exists(root .. "/Cargo.toml") then
        return { kind = "rust", root = root, cmd = "cargo run" }
    end
end

local function detect_csharp(root)
    local sln = fn.glob(root .. "/*.sln", false, true)[1]
    if sln and sln ~= "" then
        return { kind = "csharp", root = root, cmd = "dotnet run" }
    end
    local csproj = fn.glob(root .. "/*.csproj", false, true)[1]
    if csproj and csproj ~= "" then
        return { kind = "csharp", root = root, cmd = ('dotnet run --project "%s"'):format(csproj) }
    end
end

local function detect_angular(root)
    local pkg = root .. "/package.json"
    local ang = root .. "/angular.json"
    if not (exists(pkg) and exists(ang)) then
        return nil
    end
    local scripts = (read_json(pkg) or {}).scripts or {}
    if scripts.start then
        return { kind = "angular", root = root, cmd = "npm run start" }
    end
    return { kind = "angular", root = root, cmd = "npx ng serve" }
end

local function detect_python(root)
    if exists(root .. "/pyproject.toml") or exists(root .. "/requirements.txt") or exists(root .. "/.venv") then
        -- let “project run” be `python -m <package>` if there’s a package, but keep it simple:
        return { kind = "python", root = root, cmd = "python3 -m pip -V && python3" }
    end
end

local detectors = { detect_rust, detect_csharp, detect_angular, detect_python }

local function detect_project()
    local root = find_root()
    for _, d in ipairs(detectors) do
        local spec = d(root)
        if spec then
            return spec
        end
    end
    return { kind = "shell", root = root, cmd = (os.getenv("SHELL") or "bash") }
end

-- --- terminal mgmt ---------------------------------------------------
local function key_for(spec)
    return spec.root .. "::" .. spec.kind
end

-- Always send the command when opening/toggling
local function open_and_run(spec)
    local key = key_for(spec)
    local entry = terms[key]

    if not entry then
        entry = {
            term = Terminal:new({
                dir = spec.root,
                hidden = true,
                close_on_exit = true,
                on_close = function()
                    if prev_win and api.nvim_win_is_valid(prev_win) then
                        api.nvim_set_current_win(prev_win)
                    end
                    prev_win = nil
                end,
            }),
        }
        terms[key] = entry
    else
        -- ensure directory is current if you moved roots around
        entry.term.dir = spec.root
    end

    prev_win = api.nvim_get_current_win()

    -- Open the terminal (if it’s visible, this will hide it; ensure it opens)
    if entry.term:is_open() then
        entry.term:toggle()
    end
    entry.term:open() -- now definitely visible

    -- cd to root and run the command freshly every time
    entry.term:send(('cd "%s"'):format(spec.root), true)
    entry.term:send(spec.cmd, true)
    -- optional: jump to insert to see live output
    vim.cmd("startinsert")
end

-- --- public API -------------------------------------------------------
function M.run_project()
    local spec = detect_project()
    open_and_run(spec)
end

-- Run the *current file* with a sensible default per filetype
function M.run_current_file()
    -- save first so we execute latest
    vim.cmd.write()

    local root = find_root()
    local file = api.nvim_buf_get_name(0)
    local ft = vim.bo.filetype
    local cmd

    if ft == "python" then
        cmd = ('python3 "%s"'):format(file)
    elseif ft == "rust" then
        cmd = "cargo run"
    elseif ft == "cs" or ft == "csharp" then
        -- try to run the project; if you want single-file scriptcs or dotnet-script, adjust here
        local csproj = fn.glob(root .. "/*.csproj", false, true)[1]
        cmd = csproj and ('dotnet run --project "%s"'):format(csproj) or "dotnet run"
    elseif
        ft == "typescript"
        or ft == "typescriptreact"
        or ft == "javascript"
        or ft == "javascriptreact"
        or ft == "html"
    then
        -- Angular/Node: prefer npm start if present
        local pkg = root .. "/package.json"
        local scripts = exists(pkg) and (read_json(pkg).scripts or {}) or {}
        if scripts.start then
            cmd = "npm run start"
        else
            cmd = ('node "%s"'):format(file)
        end
    else
        -- last resort: try to execute the file directly
        cmd = ('"%s"'):format(file)
    end

    open_and_run({ kind = "runfile", root = root, cmd = cmd })
end

-- ad-hoc command in project root
function M.run_cmd(cmd)
    local root = find_root()
    open_and_run({ kind = "custom", root = root, cmd = cmd })
end

return M
