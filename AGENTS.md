# AGENTS.md — Neovim Rewrite Instructions

## Project purpose

This repository is a personal Neovim configuration rewrite.

The goal is not to recreate LazyVim wholesale. The goal is to keep the LazyVim workflows I actually liked while removing the distro layer and making the config explicit, understandable, modular, and maintainable.

This config is currently in the “get working first” phase. Later we will optimize, reduce duplication, and refactor structure.

## User priorities

Prefer:

- explicit configuration over hidden distro behavior
- understandable modules over clever abstractions
- small, isolated changes
- preserving existing keymaps unless asked otherwise
- working behavior first, cleanup second
- maintainability over minimal line count
- Linux-first, but keep Windows compatibility where practical

Avoid:

- large rewrites without asking
- replacing working plugins just to be more minimal
- broad “cleanup” passes that change behavior
- introducing plugin overlap
- silently changing keymaps
- adding autoformat/autofix behavior that can rewrite code unexpectedly
- assuming LazyVim defaults are present

## Current architecture

The config uses:

- `lazy.nvim` as plugin manager
- no LazyVim distro
- custom auto-loader for `lua/config/*.lua`
- plugin specs in `lua/plugins/*.lua`
- personal snippets in `lua/snippets/*.lua`
- colorscheme entrypoints in `colors/*.lua`
- actual theme implementation can live under `lua/theme/*.lua`

Important rule:

- `lua/config/` is auto-required.
- `lua/plugins/` is imported by lazy.nvim.
- `lua/snippets/` is loaded by LuaSnip.
- `lua/theme/` is not auto-loaded.
- `colors/` is where Neovim discovers colorschemes.

Do not blindly require every Lua file.

## Current plugin decisions

Accepted core stack:

- Plugin manager: `lazy.nvim`
- Picker/dashboard/bigfile/quickfile: `snacks.nvim`
- File explorer: `neo-tree.nvim`
- Statusline: `lualine.nvim`
- Bufferline: `bufferline.nvim`
- Editing helpers: `mini.nvim`
  - `mini.comment`
  - `mini.surround`
  - `mini.pairs`
  - `mini.ai`
  - `mini.extra`
- Treesitter: `nvim-treesitter`
- LSP tooling: Mason + native Neovim LSP
- Completion: `blink.cmp`
- Snippets: `LuaSnip` + `friendly-snippets` + personal snippets
- Formatting: `conform.nvim`
- Git:
  - `gitsigns.nvim`
  - `diffview.nvim`
  - `conflict-marker.vim`
  - `Snacks.lazygit()`
- Diagnostics UI: `trouble.nvim`, manual/toggled only
- Debugging:
  - `nvim-dap`
  - `nvim-dap-ui`
  - `nvim-dap-virtual-text`
  - `nvim-dap-python`

Deferred or optional:

- Noice is parked/disabled or under suspicion.
- AI plugins are not core yet.
- JS/TS DAP is deferred.
- Runner/build integration is planned but not implemented yet.
- Code optimization/refactor pass is planned after behavior stabilizes.

## Known issue

There is a UI/rendering artifact where repeated lualine/statusline-looking text can render in the lower area.

Observed:

- happened on Windows and Linux
- not caused by Noice alone
- happened even with Noice disabled
- file content was not corrupted when checked with buffer line inspection
- currently parked for later investigation

Do not attempt a large UI rewrite solely for this unless explicitly tasked.

## Key behavior to preserve

General:

- `<leader>` is space.
- `;`, `æ`, and `Æ` open command mode.
- `n` / `N` center search result.
- `<C-d>` / `<C-u>` center after movement.
- `<Esc>` exits terminal mode.
- No `jk` terminal escape.

Bufferline:

- User actively uses bufferline.
- Do not remove bufferline.
- Bufferline is used with keymaps, not primarily mouse clicks.
- Preserve close-left/right/others workflows unless explicitly changed.

Snippets/completion:

- Blink owns completion keymaps.
- Enter accepts completion.
- Tab moves through completion/snippet placeholders.
- Personal snippets should have high priority.
- `friendly-snippets` is intentionally included.
- Do not add manual LuaSnip Tab mappings unless there is a good reason.

Textobjects:

- `vag` must select the whole buffer/file.
- This comes from `mini.ai` + `mini.extra` buffer textobject.
- Do not remove `mini.ai`.

Formatting:

- Conform is intended to format on save, but with guardrails.
- Safe languages can autoformat.
- Risky languages like C/C++/C#/SQL should only autoformat when project formatter config exists.
- Do not enable broad destructive formatting without asking.

DAP:

- Python uses debugpy.
- Rust/C/C++ use codelldb.
- C# uses netcoredbg.
- DAP should degrade gracefully if an adapter is missing.
- Missing adapters should notify, not break startup.

## Coding style

Lua style:

- Prefer simple local helper functions.
- Prefer explicit plugin specs.
- Avoid clever metaprogramming unless it clearly reduces repeated boilerplate.
- Keep plugin files focused by concern.
- Use `vim.uv`, not deprecated `vim.loop`, unless compatibility requires otherwise.
- Use native Neovim 0.12 LSP APIs:
  - `vim.lsp.config`
  - `vim.lsp.enable`

Do not use old `require("lspconfig").server.setup({})` style unless explicitly justified.

## Testing/smoke checks

After changes, run at least:

```sh
nvim --headless "+qa"
```
