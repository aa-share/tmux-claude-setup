# tmux cheat sheet

Your tmux setup works like a set of terminal tabs that keep running when you
close the terminal window. Config: `~/.tmux.conf` · this file: `~/.tmux-help.md` · show it: `tmhelp` or `Ctrl+b H`

## The basic idea

tmux organizes things in three levels:

- **Session**: one per project (`main`, `credit`, `local-linux`…). `cs` creates these.
- **Window**: like a tab inside a session. Use one per Claude session or task. Listed in the top bar as `1:linux 2:fix-ci`.
- **Pane**: a split inside a window, for example Claude on the left and a shell on the right.

Everything keeps running when you close GNOME Terminal. Press **Super+T** and you're
back where you left off. It doesn't survive a reboot.

## The prefix key

Every shortcut starts with the **prefix**: press **Ctrl+b**, let go, then press the next key.
So "Ctrl+b c" means Ctrl+b, release, then c.

Claude Code also uses Ctrl+b (move a running command to the background).
Inside tmux, press **Ctrl+b twice** to send it to Claude.

## Windows (what you'll use most)

- `Ctrl+PgDn` / `Ctrl+PgUp`: next / previous window (no prefix, like GNOME Terminal tabs)
- `Ctrl+Shift+PgDn` / `PgUp`: move the current window right / left
- `Ctrl+N` or `Ctrl+b c`: new window, opened in the current folder.
  Inside vim or nano, Ctrl+N goes to the editor; `Ctrl+b Ctrl+N` sends it to any program.
- `Ctrl+b 1`…`9`: go to window number N
- `Ctrl+b n` / `p`: next / previous window (prefix version)
- `Ctrl+b l`: back to the last window you used
- `Ctrl+b w`: pick a window from a list (arrow keys, then Enter)
- `Ctrl+b ,`: rename a window (stops the automatic Claude-name title for it)
- `Ctrl+W` or `Ctrl+b &`: close the window. Ctrl+W asks first (`y` / `n`) only when something
  still runs there, such as Claude or a server; a window with just an idle shell closes at once.
- **Delete a word** while typing (what Ctrl+W does elsewhere): `Alt+Backspace`, in bash and in Claude.
  Inside vim or nano, Ctrl+W goes to the editor; `Ctrl+b Ctrl+W` sends it to any program.

Typing `exit` in a window's shell also closes it. In the **last** window that ends
the whole session; close the terminal window instead to keep it running.

## Sessions (projects)

- `cs` or `Ctrl+b P`: open or switch to a project's session
- `Ctrl+b s`: list all sessions; `→` expands one to show its windows
- `Ctrl+b (` / `)`: previous / next session
- `Ctrl+b L`: back to the last session you used
- `Ctrl+b $`: rename the session
- `Ctrl+b d`: **detach**, leave tmux while everything keeps running
- `tmux ls`: from a normal shell, list sessions
- `tmux a -t credit`: from a normal shell, reattach to a session
- `tmux kill-session -t credit`: close a whole project session

A session called `main-1` may show up while two Super+T windows are open. It's just
the second window's view of `main` and disappears when you close that window.

## Claude helpers

- `cs [query]`: pick a project; its session starts with `claude -n <project>`
- `cw <name>`: another named Claude session in a new window, same folder
- `ca` or `Ctrl+b A`: agent view, every Claude session in one list
- `cgrep <text>` or `Ctrl+b F`: search this window's Claude conversation (see below)

A **yellow** window in the top bar means Claude finished or is waiting for you there.

## Panes (splits)

- `Ctrl+b |` / `Ctrl+b -`: split side by side / top and bottom
- `Ctrl+b ←↑→↓`: move to another pane (clicking it works too)
- `Ctrl+b z`: zoom the pane to full screen; press again to unzoom
- `Ctrl+b Ctrl+←↑→↓`: resize (dragging the border also works)
- `Ctrl+b Space`: cycle through layouts
- `Ctrl+b !`: turn the pane into its own window
- `Ctrl+b x`: close the pane

## Panes or windows?

Panes are for things you want to **see at the same time**. Windows are for things you
**switch between**. Sessions are for separate projects.

**Use a new window when…**

- **It's another Claude session.** Give each Claude its own window (`cw <name>`):
  - Claude needs width; in a narrow pane its answers and diffs wrap badly.
  - The yellow "needs you" marker and the notification point to a window, not a pane.
  - You can only read one Claude at a time anyway.
- **It's a separate task:** git work, a server, `lazydocker`, a `man` page.
- **It runs long and you only check it now and then:** dev server, build, `docker compose logs`.
  Name the window (`Ctrl+b ,`) so you can find it.

**Use a pane when…**

- **You glance at it while working next to it:**
  - Claude on top, a short shell below for tests, server output or `git diff`.
    Use a **bottom split** (`Ctrl+b -`) so Claude keeps its full width; shrink it with `Ctrl+b Ctrl+↓`.
  - Logs next to the command that writes them (`tail -f app.log`).
  - Comparing two files or two outputs side by side.
- **Agent teammates:** tmux opens them as panes automatically. `Ctrl+b z` zooms into one.

**Signs you picked the wrong one**

- **A pane is cramped, or you keep zooming it** (`Ctrl+b z`):
  make it its own window with `Ctrl+b !`.
- **You keep switching between two windows to compare them:**
  merge them. Press `Ctrl+b :` and type `join-pane -h -s 2` to pull window 2 in as a side-by-side pane.
- **More than 3 panes in one window:** usually too many. Spread them across windows.

**A good default:** session = project (`cs credit`) · window 1 = main Claude ·
window 2 = second Claude (`cw tests`) · window 3 = shell or server ·
at most one bottom pane under a Claude window, only when you want to watch something while it works.

## Scrolling and copying

- **Mouse wheel** scrolls back through output. Press `q` to return to the live view.
- **Drag** selects and copies to the clipboard on release. **Double-click** copies a word, **triple-click** a line.
- Paste with **Ctrl+Shift+V**. Middle-click pastes your last tmux copy.
- **Shift + any mouse action** goes to GNOME Terminal instead of tmux (Shift+drag, Shift+right-click menu).
  Its selection ignores pane borders and only sees the visible screen, so prefer the tmux way.
- **Skip the mouse:** `command | wl-copy` copies a command's output; `wl-paste` pastes into a command.
- **Whole history to a file:** `tmux capture-pane -pS - > out.txt`
- **In Claude Code:** `/copy` copies the last answer cleanly, without the screen line breaks (`/copy 2` the one before).
  `/export` saves the whole conversation. Ctrl+V pastes a screenshot into Claude.
- **Keyboard:** `Ctrl+b [` starts scroll mode, where vim keys work:
  - `/` searches, `n` jumps to the next match
  - `g` / `G` go to the top / bottom
  - `v` starts a selection, `y` copies it
  - `q` leaves scroll mode

## Searching Claude's answers

Scroll mode can't search a Claude window: Claude Code draws its own screen, so
tmux never gets its history. Search the session's conversation instead:

- `Ctrl+b F`, type the text, Enter: opens the conversation of the Claude in **this window**
  in a popup, at the latest match. Enter with no text opens it at the end.
- `cgrep <text>` does the same from a shell, for example in a pane under Claude.
  Outside tmux it uses the newest Claude session started in the current folder.
- In the viewer: `n` jumps to the **older** match, `N` to the newer one; `?text` searches again,
  `g` / `G` go to the start / end, `q` closes it.
- `cgrep <text> | cat` just prints the matching lines.

It shows your prompts and Claude's answers, not tool output, and the search ignores case.

## A typical day

1. **Super+T** opens `main`, good for quick shell work.
2. **`cs credit`** switches to the credit project, with Claude already running.
3. Second task in parallel? **`cw tests`** opens a new window with another Claude session.
4. **`Ctrl+b L`** takes you back to the previous session while those run.
5. A **yellow** window (plus a desktop notification) is done or waiting. Click the notification, or press **`Ctrl+b w`**, to jump there.
6. **`ca`** shows every Claude session in one list, across projects.
7. At the end of the day, close the terminal. Everything is still there tomorrow until you reboot.

## When you're stuck

- `tmhelp` or `Ctrl+b H` shows this cheat sheet (`q` closes the popup).
- `Ctrl+b ?` lists every shortcut (`q` closes the list).
- `Ctrl+b :` opens the tmux command prompt.
- `Ctrl+b r` reloads `~/.tmux.conf` after you edit it.
- Pressed the prefix by accident? Press `Esc`.

To start, just use `Ctrl+b c`, the window numbers, `Ctrl+b d` and `cs`.
