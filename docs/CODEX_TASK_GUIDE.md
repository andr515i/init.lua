
# CODEX_TASK_GUIDE.md — Neovim Rewrite Task Playbook

This file contains task-specific playbooks for Codex.

`AGENTS.md` contains the always-on project rules.
`docs/KEYMAPS.md` contains the keymap reference.
This file contains concrete tasks Codex can run without guessing the project direction.

## How Codex should use this file

Before starting a task:

1. Read `AGENTS.md`.
2. Read the relevant section of this file.
3. Inspect the current config files.
4. Make a small plan.
5. Change only what the task requires.
6. Update `docs/KEYMAPS.md` if keymaps change.
7. Run basic checks.
8. Report what changed and what was not verified.

Do not treat this file as permission to do every listed task at once.

---

# Task: verify DAP setup

## Goal

Verify that the debugger stack loads cleanly and that missing adapters do not break startup.

Current intended adapters:

* Python: `debugpy`
* Rust: `codelldb`
* C/C++: `codelldb`
* C#: `netcoredbg`

## Relevant files

* `lua/plugins/dap.lua`
* `lua/plugins/mason.lua`
* `docs/KEYMAPS.md`

## Rules

* Missing adapters should warn, not throw startup errors.
* Do not add JavaScript/TypeScript DAP in this task.
* Do not refactor unrelated plugin files.
* Do not change DAP keymaps unless necessary.
* If keymaps change, update `docs/KEYMAPS.md`.

## Checks

Run:

```sh
nvim --headless "+qa"
```

Inside Neovim, manually inspect:

```vim
:Mason
:lua print(vim.inspect(require("dap").configurations.python))
:lua print(vim.inspect(require("dap").configurations.rust))
:lua print(vim.inspect(require("dap").configurations.cpp))
:lua print(vim.inspect(require("dap").configurations.cs))
```

## Expected result

* Startup does not error.
* Python has at least one launch config if `debugpy` is installed.
* Rust/C/C++ have launch configs if `codelldb` is installed.
* C# has a launch config if `netcoredbg` is installed.
* Missing adapters produce warnings only.

---

# Task: add project runner

## Goal

Add a simple custom runner system.

The runner should support:

* run project
* run current file
* run tests
* run project interactively in a terminal
* run current file interactively in a terminal
* stop running job
* toggle output

## Planned keymaps

```text
<leader>rr  run project
<leader>rf  run current file
<leader>rt  run tests
<leader>ri  run project interactively in a terminal
<leader>rI  run current file interactively in a terminal
<leader>rs  stop runner
<leader>ro  toggle runner output
```

Update `docs/KEYMAPS.md` when implemented.

## Project detection

Initial detection should support:

* `Cargo.toml` -> Rust / Cargo
* `package.json` -> Node / npm / pnpm
* `pyproject.toml` -> Python
* `*.csproj` / `*.sln` -> .NET
* `CMakeLists.txt` -> CMake
* `Makefile` -> Make

## Design constraints

* Keep v1 simple.
* Keep captured output and interactive terminal mode separate.
* One persistent runner output buffer is enough for captured jobs.
* Use a native Neovim terminal for interactive/TUI commands.
* Rerunning should stop the previous job if still running.
* Do not integrate with DAP unless explicitly requested.
* Do not add ToggleTerm unless there is a clear reason.
* Prefer native jobs/terminals first.

## Suggested files

Possible new files:

* `lua/config/80_runner.lua`
* `lua/util/project.lua`
* `lua/util/runner.lua`

Do not over-abstract in the first pass.

---

# Task: optionally improve DAP + runner integration

## Goal

Optional/deferred future task: after the runner is stable and the user asks for it, make debugging less manual.

Desired future behavior:

* build project
* locate executable
* start DAP with the executable

## Examples

Rust:

* build with `cargo build`
* debug `target/debug/<package-name>`

C/C++:

* use CMake build directory if present
* otherwise prompt for executable

C#:

* build with `dotnet build`
* debug selected DLL

## Rules

* Do not treat this as the next required runner step.
* Do not make DAP auto-build before the basic runner is stable.
* Keep prompt-based executable selection as fallback.
* Do not remove manual DAP configs.

---

# Task: C# LSP pass

## Goal

Add a clean C# LSP setup.

## Candidates

Evaluate one of:

* `csharp_ls`
* `omnisharp`
* Roslyn-based server, if practical

## Rules

* Do not enable multiple C# LSPs at once unless explicitly justified.
* Keep Mason installation separate from actual LSP config.
* Use `vim.lsp.config` and `vim.lsp.enable`.
* Do not use old `require("lspconfig").SERVER.setup({})` style.

## Relevant files

* `lua/plugins/mason.lua`
* `lua/config/60_lsp.lua`

---

# Task: investigate duplicate lualine render artifact

## Known facts

A repeated lualine/statusline-looking artifact can render in the lower area.

Observed:

* on Linux
* on Windows
* with Noice disabled
* with file content still clean
* after lualine config changes

## Goal

Find the cause without rewriting the UI stack blindly.

## Investigation steps

Test one variable at a time:

1. Start with current config.
2. Disable custom colorscheme.
3. Disable bufferline.
4. Disable Snacks dashboard.
5. Use minimal lualine config.
6. Test `laststatus = 2` vs `laststatus = 3`.
7. Test with and without `cmdheight = 1`.
8. Check whether artifact is a real buffer/window or redraw garbage.

## Useful command

When the artifact appears:

```vim
:lua print(vim.inspect({
  buf = vim.api.nvim_get_current_buf(),
  name = vim.api.nvim_buf_get_name(0),
  ft = vim.bo.filetype,
  bt = vim.bo.buftype,
  listed = vim.bo.buflisted,
  modifiable = vim.bo.modifiable,
  lines = vim.api.nvim_buf_line_count(0),
  cmdheight = vim.o.cmdheight,
  laststatus = vim.o.laststatus,
  statusline = vim.o.statusline,
}))
```

## Rules

* Do not remove lualine permanently.
* Do not remove bufferline permanently.
* Do not re-enable Noice as a fix unless tested.
* Keep changes small and reversible.

---

# Task: improve theme highlights

## Goal

Polish the custom colorscheme without replacing it.

## Priority highlight areas

* Treesitter syntax groups
* LSP diagnostics
* Blink completion menu
* Snacks picker
* Neo-tree
* Bufferline
* Lualine
* Diffview
* Gitsigns
* DAP UI
* Trouble

## Rules

* Keep the user’s colorscheme.
* Do not replace it with a public theme.
* Prefer a small palette table.
* Avoid giant copied highlight dumps.
* Add highlights gradually by plugin area.

## Relevant paths

* `colors/*.lua`
* `lua/theme/*.lua`

---

# Task: optimize config structure

## Only do this after behavior is stable

The config is currently allowed to be somewhat verbose because the priority has been getting behavior working.

## Allowed refactors

* extract shared path helpers into `lua/util/path.lua`
* extract project-root helpers into `lua/util/project.lua`
* extract keymap helper into `lua/util/keymap.lua`
* reduce duplicated Mason/DAP path logic
* split very large plugin specs if it improves readability
* normalize plugin spec style

## Not allowed without explicit approval

* replacing Neo-tree with Oil
* removing bufferline
* removing mini.ai
* changing completion behavior
* changing formatting policy
* removing Snacks picker
* removing DAP adapters
* changing leader key
* broad keymap rewrites

## Success criteria

After refactor:

* behavior is unchanged
* keymaps still match `docs/KEYMAPS.md`
* startup works
* no obvious plugin load errors

---

# Task: comment pass

## Goal

Add useful comments explaining the config.

## Comment what matters

Comment:

* module purpose
* plugin responsibility
* why specific plugins are kept
* why modules are disabled
* compatibility hacks
* project-specific tradeoffs
* risky behavior guardrails
* known weirdness

Do not comment every line.

## Bad comments

```lua
-- Set number to true
vim.opt.number = true
```

```lua
-- Require dap
local dap = require("dap")
```

## Good comments

```lua
-- Use global statusline so lualine owns the mode/file/status area instead of
-- Neovim's default per-window statusline.
vim.opt.laststatus = 3
```

```lua
-- Missing DAP adapters should not break startup. Mason may install them later,
-- especially on fresh Linux/Windows machines.
local debugpy = find_debugpy()
```

## Rules

* Keep comments short.
* Prefer section headers over line-by-line noise.
* Explain why, not just what.

---

# Task: update keymap docs

## Goal

Keep `docs/KEYMAPS.md` aligned with the actual Lua config.

## Files to inspect

* `lua/config/30_keymaps.lua`
* `lua/plugins/snacks.lua`
* `lua/plugins/bufferline.lua`
* `lua/plugins/neo-tree.lua`
* `lua/plugins/mini.lua`
* `lua/config/60_lsp.lua`
* `lua/plugins/conform.lua`
* `lua/plugins/git.lua`
* `lua/plugins/trouble.lua`
* `lua/plugins/dap.lua`

## Rules

* Do not invent keymaps.
* Remove stale mappings from the docs.
* Add new mappings with plain-language descriptions.
* If a mapping is plugin-local, say so.
* If a mapping is planned but not implemented, keep it in a “planned” section.

---

# Reporting format

After a task, report:

```text
Changed:
- file A
- file B

Behavior:
- what now works
- what changed

Checks:
- command run
- result

Not verified:
- anything that needs manual testing
```
