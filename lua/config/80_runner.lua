local map = vim.keymap.set

local state = {
	buf = nil,
	win = nil,
	job = nil,
	run_id = 0,
}

local terminal_state = {
	buf = nil,
	win = nil,
	job = nil,
	run_id = 0,
}

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Runner" })
end

local function path_join(...)
	local sep = package.config:sub(1, 1)
	return table.concat({ ... }, sep)
end

local function exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function is_dir(path)
	local stat = vim.uv.fs_stat(path)
	return stat and stat.type == "directory"
end

local function parent_dir(path)
	local parent = vim.fn.fnamemodify(path, ":h")
	if parent == path then
		return nil
	end
	return parent
end

local function current_start_dir()
	local file = vim.api.nvim_buf_get_name(0)

	if file ~= "" and vim.bo.buftype == "" then
		return vim.fn.fnamemodify(file, ":p:h")
	end

	return vim.fn.getcwd()
end

local function find_dotnet_marker(dir)
	local sln = vim.fn.globpath(dir, "*.sln", false, true)
	if #sln > 0 then
		return "sln"
	end

	local csproj = vim.fn.globpath(dir, "*.csproj", false, true)
	if #csproj > 0 then
		return "csproj"
	end

	return nil
end

local function detect_project()
	local dir = current_start_dir()
	if not is_dir(dir) then
		dir = vim.fn.getcwd()
	end

	while dir do
		-- Nearest directory wins; inside one directory, keep this explicit precedence.
		if exists(path_join(dir, "Cargo.toml")) then
			return { kind = "cargo", root = dir }
		end

		if exists(path_join(dir, "package.json")) then
			return { kind = "node", root = dir }
		end

		if exists(path_join(dir, "pyproject.toml")) then
			return { kind = "python", root = dir }
		end

		local dotnet = find_dotnet_marker(dir)
		if dotnet then
			return { kind = "dotnet", root = dir, marker = dotnet }
		end

		if exists(path_join(dir, "Makefile")) then
			return { kind = "make", root = dir }
		end

		if exists(path_join(dir, "CMakeLists.txt")) then
			return { kind = "cmake", root = dir }
		end

		dir = parent_dir(dir)
	end

	return nil
end

local function ensure_buffer()
	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		return state.buf
	end

	state.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(state.buf, "Runner")
	vim.bo[state.buf].buftype = "nofile"
	vim.bo[state.buf].bufhidden = "hide"
	vim.bo[state.buf].swapfile = false
	vim.bo[state.buf].filetype = "runner"

	return state.buf
end

local function runner_window()
	local buf = ensure_buffer()

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			return win
		end
	end

	return nil
end

local function open_output()
	local buf = ensure_buffer()
	local win = runner_window()

	if win and vim.api.nvim_win_is_valid(win) then
		state.win = win
		return win
	end

	vim.cmd("botright 12split")
	state.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(state.win, buf)
	vim.wo[state.win].winfixheight = true

	return state.win
end

local function append(lines)
	local buf = ensure_buffer()

	if type(lines) == "string" then
		lines = { lines }
	end

	local clean = {}
	for _, line in ipairs(lines or {}) do
		if line ~= "" then
			table.insert(clean, line)
		end
	end

	if #clean == 0 then
		return
	end

	vim.api.nvim_buf_set_lines(buf, -1, -1, false, clean)

	local win = runner_window()
	if win then
		vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
	end
end

local function append_scheduled(run_id, data)
	vim.schedule(function()
		if run_id == state.run_id then
			append(data)
		end
	end)
end

local function command_text(command)
	local parts = {}
	for _, part in ipairs(command) do
		table.insert(parts, vim.fn.shellescape(tostring(part)))
	end
	return table.concat(parts, " ")
end

local function clear_output()
	local buf = ensure_buffer()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
end

local function stop_job(opts)
	opts = opts or {}

	if not state.job then
		if opts.notify ~= false then
			notify("No runner job is active")
		end
		return
	end

	local job = state.job
	state.job = nil
	vim.fn.jobstop(job)

	if opts.notify ~= false then
		notify("Stopped runner job")
	end

	return true
end

local function start_job(spec)
	stop_job({ notify = false })

	state.run_id = state.run_id + 1
	local run_id = state.run_id

	clear_output()
	open_output()

	append({
		"$ " .. command_text(spec.command),
		"cwd: " .. spec.cwd,
		"",
	})

	-- Captured runner mode is for non-interactive commands where stdout/stderr
	-- should be collected into one persistent scratch buffer.
	local job = vim.fn.jobstart(spec.command, {
		cwd = spec.cwd,
		stdout_buffered = false,
		stderr_buffered = false,
		on_stdout = function(_, data)
			append_scheduled(run_id, data)
		end,
		on_stderr = function(_, data)
			append_scheduled(run_id, data)
		end,
		on_exit = function(_, code)
			vim.schedule(function()
				if run_id ~= state.run_id then
					return
				end

				state.job = nil
				append({ "", ("[runner exited with code %d]"):format(code) })
			end)
		end,
	})

	if job <= 0 then
		state.job = nil
		append({ "", "[runner failed to start]" })
		notify("Failed to start: " .. command_text(spec.command), vim.log.levels.ERROR)
		return
	end

	state.job = job
end

local function terminal_window()
	if not (terminal_state.buf and vim.api.nvim_buf_is_valid(terminal_state.buf)) then
		return nil
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == terminal_state.buf then
			return win
		end
	end

	return nil
end

local function open_terminal_window()
	local win = terminal_window()

	if win and vim.api.nvim_win_is_valid(win) then
		terminal_state.win = win
		return win
	end

	vim.cmd("botright 15split")
	terminal_state.win = vim.api.nvim_get_current_win()
	vim.wo[terminal_state.win].winfixheight = true

	return terminal_state.win
end

local function delete_terminal_buffer()
	if terminal_state.buf and vim.api.nvim_buf_is_valid(terminal_state.buf) then
		pcall(vim.api.nvim_buf_delete, terminal_state.buf, { force = true })
	end

	terminal_state.buf = nil
end

local function stop_terminal_job(opts)
	opts = opts or {}

	if not terminal_state.job then
		return false
	end

	local job = terminal_state.job
	terminal_state.job = nil
	terminal_state.run_id = terminal_state.run_id + 1
	pcall(vim.fn.jobstop, job)

	if opts.notify ~= false then
		notify("Stopped interactive runner job")
	end

	return true
end

local function set_terminal_name(buf)
	if pcall(vim.api.nvim_buf_set_name, buf, "Runner Terminal") then
		return
	end

	pcall(vim.api.nvim_buf_set_name, buf, "Runner Terminal " .. terminal_state.run_id)
end

local function start_terminal(spec)
	stop_terminal_job({ notify = false })

	terminal_state.run_id = terminal_state.run_id + 1
	local run_id = terminal_state.run_id
	local win = open_terminal_window()

	delete_terminal_buffer()

	local buf = vim.api.nvim_create_buf(false, false)
	terminal_state.buf = buf

	vim.api.nvim_set_current_win(win)
	vim.api.nvim_win_set_buf(win, buf)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false

	-- Interactive runner mode uses a real terminal/PTY so stdin, TUIs, and
	-- terminal control sequences work. Keep this separate from captured output.
	local job = vim.fn.jobstart(spec.command, {
		cwd = spec.cwd,
		term = true,
		on_exit = function(_, code)
			vim.schedule(function()
				if run_id ~= terminal_state.run_id then
					return
				end

				terminal_state.job = nil
				notify(("Interactive runner exited with code %d"):format(code))
			end)
		end,
	})

	if job <= 0 then
		terminal_state.job = nil
		notify("Failed to start terminal: " .. command_text(spec.command), vim.log.levels.ERROR)
		return
	end

	terminal_state.job = job
	set_terminal_name(buf)
	vim.cmd("startinsert")
end

local function read_package_json(root)
	local path = path_join(root, "package.json")
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return nil
	end

	local ok_decode, package = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not ok_decode or type(package) ~= "table" then
		return nil
	end

	return package
end

local function node_manager(root)
	if exists(path_join(root, "pnpm-lock.yaml")) then
		return "pnpm"
	end

	if exists(path_join(root, "yarn.lock")) then
		return "yarn"
	end

	return "npm"
end

local function node_script_command(root, script)
	local manager = node_manager(root)

	if manager == "npm" then
		return { "npm", "run", script }
	end

	return { manager, script }
end

local function node_spec(project, action)
	local package = read_package_json(project.root)
	local scripts = package and package.scripts

	if type(scripts) ~= "table" then
		notify("package.json has no scripts table", vim.log.levels.WARN)
		return nil
	end

	if action == "run" then
		local script = scripts.dev and "dev" or scripts.start and "start" or nil
		if not script then
			notify("package.json needs a dev or start script for <leader>rr", vim.log.levels.WARN)
			return nil
		end

		return { cwd = project.root, command = node_script_command(project.root, script) }
	end

	if action == "test" then
		if not scripts.test then
			notify("package.json has no test script", vim.log.levels.WARN)
			return nil
		end

		return { cwd = project.root, command = node_script_command(project.root, "test") }
	end

	return nil
end

local function project_spec(action)
	local project = detect_project()

	if not project then
		notify("No supported project marker found", vim.log.levels.WARN)
		return nil
	end

	if project.kind == "cargo" then
		return {
			cwd = project.root,
			command = action == "test" and { "cargo", "test" } or { "cargo", "run" },
		}
	end

	if project.kind == "node" then
		return node_spec(project, action)
	end

	if project.kind == "python" then
		if action == "test" then
			return { cwd = project.root, command = { "python", "-m", "pytest" } }
		end

		if exists(path_join(project.root, "main.py")) then
			return { cwd = project.root, command = { "python", "main.py" } }
		end

		notify("Python project run needs root main.py or <leader>rf", vim.log.levels.WARN)
		return nil
	end

	if project.kind == "dotnet" then
		return {
			cwd = project.root,
			command = action == "test" and { "dotnet", "test" } or { "dotnet", "run" },
		}
	end

	if project.kind == "make" then
		return {
			cwd = project.root,
			command = action == "test" and { "make", "test" } or { "make" },
		}
	end

	if project.kind == "cmake" then
		notify("CMake runner support is deferred; build dirs and targets need an explicit design", vim.log.levels.WARN)
		return nil
	end

	return nil
end

local function current_file_spec()
	local file = vim.api.nvim_buf_get_name(0)

	if file == "" or vim.bo.buftype ~= "" then
		notify("Current buffer is not a runnable file", vim.log.levels.WARN)
		return nil
	end

	if vim.fn.fnamemodify(file, ":e") ~= "py" then
		notify("Run current file supports Python files only in v1", vim.log.levels.WARN)
		return nil
	end

	local project = detect_project()
	local cwd = project and project.root or vim.fn.fnamemodify(file, ":p:h")

	return {
		cwd = cwd,
		command = { "python", vim.fn.fnamemodify(file, ":p") },
	}
end

local function run_project()
	local spec = project_spec("run")
	if spec then
		start_job(spec)
	end
end

local function run_current_file()
	local spec = current_file_spec()
	if spec then
		start_job(spec)
	end
end

local function run_tests()
	local spec = project_spec("test")
	if spec then
		start_job(spec)
	end
end

local function run_project_interactive()
	local spec = project_spec("run")
	if spec then
		start_terminal(spec)
	end
end

local function run_current_file_interactive()
	local spec = current_file_spec()
	if spec then
		start_terminal(spec)
	end
end

local function stop_runner()
	local stopped = stop_job({ notify = false })
	stopped = stop_terminal_job({ notify = false }) or stopped

	if stopped then
		notify("Stopped runner job")
	else
		notify("No runner job is active")
	end
end

local function toggle_output()
	local win = runner_window()

	if win then
		vim.api.nvim_win_close(win, true)
		if state.win == win then
			state.win = nil
		end
		return
	end

	open_output()
end

local function opts(desc)
	return {
		noremap = true,
		silent = true,
		desc = desc,
	}
end

map("n", "<leader>rr", run_project, opts("Run project"))
map("n", "<leader>rf", run_current_file, opts("Run current file"))
map("n", "<leader>rt", run_tests, opts("Run tests"))
map("n", "<leader>ri", run_project_interactive, opts("Run project interactively"))
map("n", "<leader>rI", run_current_file_interactive, opts("Run current file interactively"))
map("n", "<leader>rs", stop_runner, opts("Stop runner"))
map("n", "<leader>ro", toggle_output, opts("Toggle runner output"))
