# opencode + tmux workflow — deferred items

Notes on optimizations discussed but **not yet implemented**. Implemented already:
attention notifications (`~/.config/opencode/tui.json`), tmux terminal-title +
activity indicators (`tmux/tmux.conf`), and `EDITOR`/`VISUAL=nvim` in the local
(untracked) `~/.zshrc`.

## 1. Shared, tracked `.zshrc` sourced into the local one
Goal: keep common shell config in dotfiles without tracking the whole machine-specific
`~/.zshrc` (which also holds secrets). Pattern:

```bash
# tracked partial in dotfiles, e.g. zsh/shared.zsh  (no secrets)
#   EDITOR/VISUAL, aliases, shared exports

# at the bottom of the local untracked ~/.zshrc
[ -f ~/.config/zsh/shared.zsh ] && source ~/.config/zsh/shared.zsh
```
Then symlink `~/.config/zsh/shared.zsh -> ~/repos/dotfiles/zsh/shared.zsh`.
Once created, migrate `EDITOR`/`VISUAL` (currently inline in local `~/.zshrc`) into
the shared file.

## 2. opencode serve + attach multiplexing
Run one headless backend and attach TUIs/CLIs so MCP servers init once (not per pane):

```bash
opencode serve --port 4096                 # long-lived backend pane
opencode attach http://localhost:4096      # interactive TUI pane
opencode run --attach http://localhost:4096 "..."   # scripted runs, no cold boot
```
`attach` supports `--continue` / `--session <id>` to resume a specific session.
Possible future: a tmux session/layout that boots `opencode serve` automatically.

## 3. tmux session-picker popup (fzf)
Bind a popup to pick and resume an opencode session:

```tmux
bind-key o display-popup -E -w 80% -h 60% \
  "opencode -s \$(opencode session list --format json | jq -r '.[] | \"\\(.id)\\t\\(.title)\"' | fzf | cut -f1)"
```

## 4. Security follow-up (not a dotfiles change)
- Rotate the GitHub PAT currently stored in plaintext in the local `~/.zshrc`.
- Move provider secrets out of the rc file (e.g. opencode `auth.json` / a secret manager).
- Keep secrets out of any future tracked `zsh/shared.zsh`.
