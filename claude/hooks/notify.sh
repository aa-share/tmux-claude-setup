#!/usr/bin/env bash
# Desktop notification for the Claude Code Notification and Stop hooks.
# Names the session (and its tmux window when running inside tmux), and rings
# the tmux pane bell so that window is flagged in the tmux status bar.

IFS=$'\x1f' read -r -d '' event sid cwd name message < <(
    jq -j '[
        .hook_event_name // "",
        .session_id // "",
        .cwd // ".",
        .session_name // "",
        .message // ""
    ] | join("\u001f")'
)

# Hook input may not carry the session name: look it up in the live session registry.
if [ -z "$name" ] && [ -n "$sid" ]; then
    name=$(jq -r --arg sid "$sid" 'select(.sessionId == $sid) | .name // empty' \
        ~/.claude/sessions/*.json 2>/dev/null | head -n 1)
fi
dir=${cwd##*/}
[ -n "$name" ] || name=$dir

if [ "$event" = "Stop" ]; then
    body="Finished"
else
    body=${message:-"Waiting for your input"}
fi

where=$dir
if [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ]; then
    where+=" · tmux $(tmux display-message -p -t "$TMUX_PANE" '#S:#I' 2>/dev/null)"
    pane_tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
    [ -w "$pane_tty" ] && printf '\a' > "$pane_tty"
fi

notify-send -a "Claude Code" -i utilities-terminal "Claude · $name" "$body — $where"
