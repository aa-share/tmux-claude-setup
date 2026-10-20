# tmux-claude-setup

A persistent tmux workspace for running many parallel Claude Code sessions on Fedora (GNOME Terminal, Wayland, bash).

- **Super+T** attaches the `main` tmux session. Each extra terminal opens a grouped view of it, which closes with that window.
- **Status bar on top**, so it doesn't stack with Claude Code's footer. A window gets a yellow flag when Claude in it finishes or waits for input.
- **GNOME Terminal-style keys**: Ctrl+N opens a new window, Ctrl+W closes it (asks first if something is still running), Ctrl+PgUp/PgDn switches windows. Vim and nano still get Ctrl+N and Ctrl+W.
- **`cs`** opens an fzf project picker that switches to a tmux session for the project and starts `claude -n <project>` there. **`cw <name>`** starts another named Claude in a new window. **`ca`** runs `claude agents`.
- **Popups**: `prefix P` opens the project picker and `prefix A` opens the agent view.
- **Claude Code hooks**: a desktop notification names the session and tmux window, and a status line shows the model, effort, session, branch, context % and 5h limit %.

## Files

| File | Install to |
| --- | --- |
| `tmux.conf` | `~/.tmux.conf` |
| `bin/term-tmux` | `~/.local/bin/term-tmux` |
| `bash_claude` | `~/.bash_claude` (add `. ~/.bash_claude` to `~/.bashrc`) |
| `claude/hooks/notify.sh` | `~/.claude/hooks/notify.sh` |
| `claude/statusline.sh` | `~/.claude/statusline.sh` |
| `claude/settings.snippet.json` | merge into `~/.claude/settings.json` (not symlinked) |

## Install

Symlink the files from a clone, so the live config stays under git:

```bash
mkdir -p ~/.local/bin ~/.claude/hooks
ln -sf "$PWD/tmux.conf" ~/.tmux.conf
ln -sf "$PWD/bash_claude" ~/.bash_claude && echo '. ~/.bash_claude' >> ~/.bashrc
ln -sf "$PWD/bin/term-tmux" ~/.local/bin/term-tmux
ln -sf "$PWD/claude/hooks/notify.sh" ~/.claude/hooks/notify.sh
ln -sf "$PWD/claude/statusline.sh" ~/.claude/statusline.sh
```

To bind Super+T, add a GNOME custom shortcut (Settings → Keyboard → Custom Shortcuts) with this command. GNOME doesn't expand `~` itself, so `sh` does it:

```
gnome-terminal --maximize -- sh -c 'exec ~/.local/bin/term-tmux'
```

Projects for `cs` are the subfolders of the directories in `CS_ROOTS`, set in `bash_claude`.

Requires tmux 3.5 or newer (tested on 3.7c), plus `fzf`, `jq`, `wl-clipboard`, `libnotify` and Claude Code.
