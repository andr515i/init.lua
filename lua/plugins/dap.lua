local function path_join(...)
	local sep = package.config:sub(1, 1)
	local parts = { ... }

	return table.concat(parts, sep)
end

local function is_windows()
	return vim.uv.os_uname().sysname:match("Windows") ~= nil
end

local function mason_package(name)
	return path_join(vim.fn.stdpath("data"), "mason", "packages", name)
end

local function first_existing(paths)
	for _, path in ipairs(paths) do
		if vim.uv.fs_stat(path) then
			return path
		end
	end

	return nil
end

local function executable_or_notify(name, candidates)
	local path = first_existing(candidates)

	if not path then
		vim.schedule(function()
			vim.notify("DAP adapter not found for " .. name .. ". Install it with :Mason", vim.log.levels.WARN)
		end)
	end

	return path
end

local function input_executable()
	local sep = package.config:sub(1, 1)
	return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. sep, "file")
end

local function input_dll()
	local sep = package.config:sub(1, 1)
	return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. sep .. "bin" .. sep .. "Debug" .. sep, "file")
end

return {
	{
		"mfussenegger/nvim-dap",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap-python",
		},

		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Conditional breakpoint",
			},
			{
				"<leader>dl",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "Log point",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue/start debug",
			},
			{
				"<leader>dr",
				function()
					require("dap").restart()
				end,
				desc = "Restart debug",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate debug",
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
				desc = "Pause debug",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step out",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Stack frame up",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Stack frame down",
			},
			{
				"<leader>dR",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle DAP REPL",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Toggle DAP UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "x" },
				desc = "Evaluate expression",
			},
			{
				"<leader>dx",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "Clear breakpoints",
			},
			{
				"<leader>dL",
				function()
					require("dap").run_last()
				end,
				desc = "Run last debug config",
			},
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local win = is_windows()

			-- Signs.
			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DiagnosticError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointCondition", {
				text = "◆",
				texthl = "DiagnosticWarn",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapLogPoint", {
				text = "◆",
				texthl = "DiagnosticInfo",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "▶",
				texthl = "DiagnosticHint",
				linehl = "Visual",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "✖",
				texthl = "DiagnosticError",
				linehl = "",
				numhl = "",
			})

			-- UI.
			dapui.setup({
				icons = {
					expanded = "▾",
					collapsed = "▸",
					current_frame = "▶",
				},

				controls = {
					enabled = true,
					element = "repl",
				},

				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.45 },
							{ id = "breakpoints", size = 0.15 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.15 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 12,
						position = "bottom",
					},
				},

				floating = {
					border = "rounded",
				},
			})

			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = true,
			})

			-- Auto-open/close UI.
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			-- codelldb: Rust / C / C++.
			local codelldb_pkg = mason_package("codelldb")
			local codelldb = executable_or_notify("codelldb", {
				path_join(codelldb_pkg, "extension", "adapter", win and "codelldb.exe" or "codelldb"),
				path_join(codelldb_pkg, win and "codelldb.exe" or "codelldb"),
			})

			if codelldb then
				dap.adapters.codelldb = {
					type = "server",
					port = "${port}",
					executable = {
						command = codelldb,
						args = { "--port", "${port}" },
					},
				}

				local codelldb_launch = {
					name = "Launch executable",
					type = "codelldb",
					request = "launch",
					program = input_executable,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					runInTerminal = false,
				}

				dap.configurations.c = { codelldb_launch }
				dap.configurations.cpp = { codelldb_launch }
				dap.configurations.rust = { codelldb_launch }
			end

			-- Python / debugpy.
			local debugpy_pkg = mason_package("debugpy")
			local debugpy_python = executable_or_notify("debugpy", {
				path_join(debugpy_pkg, "venv", win and "Scripts" or "bin", win and "python.exe" or "python"),
				path_join(debugpy_pkg, "venv", win and "Scripts" or "bin", win and "python3.exe" or "python3"),
			})

			if debugpy_python then
				require("dap-python").setup(debugpy_python)

				dap.configurations.python = dap.configurations.python or {}

				table.insert(dap.configurations.python, 1, {
					type = "python",
					request = "launch",
					name = "Launch current file",
					program = "${file}",
					console = "integratedTerminal",
					justMyCode = false,
				})
			end

			-- C# / .NET.
			local netcoredbg_pkg = mason_package("netcoredbg")
			local netcoredbg = executable_or_notify("netcoredbg", {
				path_join(netcoredbg_pkg, "netcoredbg", win and "netcoredbg.exe" or "netcoredbg"),
				path_join(netcoredbg_pkg, win and "netcoredbg.exe" or "netcoredbg"),
			})

			if netcoredbg then
				dap.adapters.coreclr = {
					type = "executable",
					command = netcoredbg,
					args = { "--interpreter=vscode" },
				}

				dap.configurations.cs = {
					{
						name = "Launch .NET DLL",
						type = "coreclr",
						request = "launch",
						program = input_dll,
						cwd = "${workspaceFolder}",
						stopAtEntry = false,
					},
				}
			end

		end,
	},
}
