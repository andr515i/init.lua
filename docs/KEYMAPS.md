# docs/KEYMAPS.md

# Neovim Keymaps

This file documents intentional user-facing keymaps.

Update this file whenever keymaps are added, removed, or changed.

The Lua config is the source of truth, but this document should stay close enough that it can be used as a quick reference.

## Leader

| Key             | Meaning   |
| --------------- | --------- |
| `<leader>`      | Space     |
| `<localleader>` | Backslash |

## Core editing

| Key          |          Mode | Action                                    |
| ------------ | ------------: | ----------------------------------------- |
| `n`          |        Normal | Next search result and center cursor      |
| `N`          |        Normal | Previous search result and center cursor  |
| `<C-d>`      |        Normal | Half-page down and center cursor          |
| `<C-u>`      |        Normal | Half-page up and center cursor            |
| `;`          | Normal/Visual | Enter command mode                        |
| `æ`          | Normal/Visual | Enter command mode                        |
| `Æ`          | Normal/Visual | Enter command mode                        |
| `<Esc>`      |      Terminal | Exit terminal mode                        |
| `.`          |        Visual | Repeat last normal command over selection |
| `X`          |        Normal | Transpose character forward               |
| `<leader>y`  | Normal/Visual | Yank to system clipboard                  |
| `<leader>Y`  |        Normal | Yank current line to system clipboard     |
| `<A-s>`      |        Normal | Substitute word under cursor              |
| `<A-s>`      |        Visual | Substitute selected text                  |
| `<leader>va` |        Visual | Append `<br>` to selected lines           |

## Quickfix

| Key          |   Mode | Action                 |
| ------------ | -----: | ---------------------- |
| `]q`         | Normal | Next quickfix item     |
| `[q`         | Normal | Previous quickfix item |
| `<leader>qo` | Normal | Open quickfix list     |
| `<leader>qc` | Normal | Close quickfix list    |

## Buffers

| Key          |   Mode | Action                      |
| ------------ | -----: | --------------------------- |
| `<S-h>`      | Normal | Previous buffer             |
| `<S-l>`      | Normal | Next buffer                 |
| `<leader>,`  | Normal | Pick buffer with Snacks     |
| `<leader>bb` | Normal | Pick buffer with Bufferline |
| `<leader>bd` | Normal | Delete current buffer       |
| `<leader>bD` | Normal | Force delete current buffer |
| `<leader>bo` | Normal | Delete other buffers        |
| `<leader>bl` | Normal | Delete buffers to the left  |
| `<leader>br` | Normal | Delete buffers to the right |
| `<leader>bp` | Normal | Pin/unpin buffer            |
| `<leader>bH` | Normal | Move buffer left            |
| `<leader>bL` | Normal | Move buffer right           |

## Snacks picker

| Key               |          Mode | Action                             |
| ----------------- | ------------: | ---------------------------------- |
| `<leader><space>` |        Normal | Smart file picker                  |
| `<leader>/`       |        Normal | Grep project                       |
| `<leader>:`       |        Normal | Command history                    |
| `<leader>ff`      |        Normal | Find files                         |
| `<leader>fg`      |        Normal | Find git files                     |
| `<leader>fr`      |        Normal | Recent files                       |
| `<leader>fc`      |        Normal | Find config files                  |
| `<leader>sb`      |        Normal | Search current buffer lines        |
| `<leader>sB`      |        Normal | Grep open buffers                  |
| `<leader>sg`      |        Normal | Grep project                       |
| `<leader>sw`      | Normal/Visual | Grep word or selection             |
| `<leader>sk`      |        Normal | Search keymaps                     |
| `<leader>sh`      |        Normal | Search help                        |
| `<leader>sH`      |        Normal | Search highlights                  |
| `<leader>sq`      |        Normal | Search quickfix list               |
| `<leader>sd`      |        Normal | Search diagnostics                 |
| `<leader>sD`      |        Normal | Search buffer diagnostics          |
| `<leader>sr`      |        Normal | Resume last picker                 |
| `<leader>uC`      |        Normal | Pick colorscheme with live preview |

## Neo-tree

| Key          |   Mode | Action                |
| ------------ | -----: | --------------------- |
| `<leader>e`  | Normal | Toggle explorer       |
| `<leader>E`  | Normal | Focus/reveal explorer |
| `<leader>fe` | Normal | Explorer              |
| `<leader>ge` | Normal | Git status explorer   |
| `<leader>be` | Normal | Buffer explorer       |

Inside Neo-tree:

| Key                | Action               |
| ------------------ | -------------------- |
| `l` / `<CR>` / `o` | Open                 |
| `h`                | Close node           |
| `s`                | Open split           |
| `v`                | Open vertical split  |
| `t`                | Open tab             |
| `a`                | Add file             |
| `A`                | Add directory        |
| `d`                | Delete               |
| `r`                | Rename               |
| `c`                | Copy                 |
| `m`                | Move                 |
| `y`                | Copy to clipboard    |
| `x`                | Cut to clipboard     |
| `p`                | Paste from clipboard |
| `R`                | Refresh              |
| `?`                | Help                 |
| `q`                | Close window         |

## Comments / surround / pairs / textobjects

| Key          |          Mode | Action                       |
| ------------ | ------------: | ---------------------------- |
| `gcc`        |        Normal | Comment current line         |
| `gc{motion}` |        Normal | Comment motion               |
| `gc`         |        Visual | Comment selection            |
| `gsa`        | Normal/Visual | Add surround                 |
| `gsd`        |        Normal | Delete surround              |
| `gsr`        |        Normal | Replace surround             |
| `gsf`        |        Normal | Find surround right          |
| `gsF`        |        Normal | Find surround left           |
| `gsh`        |        Normal | Highlight surround           |
| `gsn`        |        Normal | Update surround search lines |

Mini.ai textobjects:

| Key                   | Meaning                                           |
| --------------------- | ------------------------------------------------- |
| `vag` / `yag` / `dag` | Whole buffer/file                                 |
| `vig`                 | Whole buffer without leading/trailing blank lines |
| `vaf` / `vif`         | Around/inside function                            |
| `vac` / `vic`         | Around/inside class                               |
| `vao` / `vio`         | Around/inside block/conditional/loop              |
| `val` / `vil`         | Around/inside current line                        |
| `vai` / `vii`         | Around/inside indent scope                        |
| `van` / `vin`         | Around/inside number                              |
| `vax` / `vix`         | Around/inside diagnostic                          |
| `vau` / `viu`         | Around/inside function call                       |
| `vaU` / `viU`         | Around/inside function call without dot in name   |

## LSP

These mappings are buffer-local and only exist when an LSP is attached.

| Key          |          Mode | Action                |
| ------------ | ------------: | --------------------- |
| `gd`         |        Normal | Go to definition      |
| `gD`         |        Normal | Go to declaration     |
| `gr`         |        Normal | References            |
| `gI`         |        Normal | Go to implementation  |
| `gy`         |        Normal | Go to type definition |
| `K`          |        Normal | Hover                 |
| `<leader>ck` |        Normal | Signature help        |
| `<leader>cr` |        Normal | Rename                |
| `<leader>ca` | Normal/Visual | Code action           |
| `<leader>cl` |        Normal | LSP log               |
| `<leader>ci` |        Normal | LSP info              |
| `<leader>cR` |        Normal | Restart LSP           |
| `<leader>ch` |        Normal | Toggle inlay hints    |

## Diagnostics

| Key          |   Mode | Action                     |
| ------------ | -----: | -------------------------- |
| `<leader>cd` | Normal | Line diagnostics float     |
| `]d`         | Normal | Next diagnostic            |
| `[d`         | Normal | Previous diagnostic        |
| `<leader>xx` | Normal | Trouble diagnostics        |
| `<leader>xX` | Normal | Trouble buffer diagnostics |
| `<leader>xq` | Normal | Trouble quickfix list      |
| `<leader>xl` | Normal | Trouble location list      |

## Formatting

| Key / Command     |          Mode | Action                                |
| ----------------- | ------------: | ------------------------------------- |
| `<leader>cf`      | Normal/Visual | Format buffer/range                   |
| `<leader>cF`      | Normal/Visual | Format with LSP only                  |
| `<leader>uf`      |        Normal | Toggle buffer autoformat              |
| `<leader>uF`      |        Normal | Toggle global autoformat              |
| `:Format`         |       Command | Format current buffer                 |
| `:Format!`        |       Command | Format with LSP only                  |
| `:FormatDisable`  |       Command | Disable autoformat for current buffer |
| `:FormatDisable!` |       Command | Disable autoformat globally           |
| `:FormatEnable`   |       Command | Enable autoformat for current buffer  |
| `:FormatEnable!`  |       Command | Enable autoformat globally            |
| `:FormatToggle`   |       Command | Toggle buffer autoformat              |
| `:FormatToggle!`  |       Command | Toggle global autoformat              |

## Git

| Key           |            Mode | Action                     |
| ------------- | --------------: | -------------------------- |
| `<leader>gg`  |          Normal | Open LazyGit               |
| `<leader>gs`  |          Normal | Git status picker          |
| `<leader>gb`  |          Normal | Git branches picker        |
| `<leader>gl`  |          Normal | Git log picker             |
| `<leader>gd`  |          Normal | Diffview open              |
| `<leader>gD`  |          Normal | Diffview last commit       |
| `<leader>gq`  |          Normal | Diffview close             |
| `<leader>ghf` |          Normal | Current file history       |
| `<leader>ghH` |          Normal | Repo history               |
| `]h`          |          Normal | Next git hunk              |
| `[h`          |          Normal | Previous git hunk          |
| `<leader>ghs` |   Normal/Visual | Stage hunk/selection       |
| `<leader>ghr` |   Normal/Visual | Reset hunk/selection       |
| `<leader>ghS` |          Normal | Stage buffer               |
| `<leader>ghu` |          Normal | Undo stage hunk            |
| `<leader>ghR` |          Normal | Reset buffer               |
| `<leader>ghp` |          Normal | Preview hunk               |
| `<leader>ghP` |          Normal | Preview hunk inline        |
| `<leader>ghb` |          Normal | Blame line                 |
| `<leader>ghd` |          Normal | Diff this                  |
| `<leader>ghD` |          Normal | Diff this against previous |
| `<leader>gtb` |          Normal | Toggle git blame           |
| `<leader>gtd` |          Normal | Toggle deleted lines       |
| `<leader>gtw` |          Normal | Toggle word diff           |
| `ih`          | Operator/Visual | Git hunk textobject        |

## Git conflicts

| Key           |   Mode | Action                 |
| ------------- | -----: | ---------------------- |
| `]x`          | Normal | Next conflict          |
| `[x`          | Normal | Previous conflict      |
| `<leader>gco` | Normal | Conflict choose ours   |
| `<leader>gct` | Normal | Conflict choose theirs |
| `<leader>gcb` | Normal | Conflict choose both   |
| `<leader>gc0` | Normal | Conflict choose none   |

## DAP / Debugging

| Key          |          Mode | Action                 |
| ------------ | ------------: | ---------------------- |
| `<leader>db` |        Normal | Toggle breakpoint      |
| `<leader>dB` |        Normal | Conditional breakpoint |
| `<leader>dl` |        Normal | Log point              |
| `<leader>dc` |        Normal | Continue/start debug   |
| `<leader>dr` |        Normal | Restart debug          |
| `<leader>dt` |        Normal | Terminate debug        |
| `<leader>dp` |        Normal | Pause debug            |
| `<leader>di` |        Normal | Step into              |
| `<leader>do` |        Normal | Step over              |
| `<leader>dO` |        Normal | Step out               |
| `<leader>dk` |        Normal | Stack frame up         |
| `<leader>dj` |        Normal | Stack frame down       |
| `<leader>dR` |        Normal | Toggle DAP REPL        |
| `<leader>du` |        Normal | Toggle DAP UI          |
| `<leader>de` | Normal/Visual | Evaluate expression    |
| `<leader>dx` |        Normal | Clear breakpoints      |
| `<leader>dL` |        Normal | Run last debug config  |

## Runner

| Key          |   Mode | Action                       |
| ------------ | -----: | ---------------------------- |
| `<leader>rr` | Normal | Run project                  |
| `<leader>rf` | Normal | Run current file             |
| `<leader>rt` | Normal | Run tests                    |
| `<leader>ri` | Normal | Run project in terminal      |
| `<leader>rI` | Normal | Run current file in terminal |
| `<leader>rs` | Normal | Stop runner                  |
| `<leader>ro` | Normal | Toggle runner output         |
