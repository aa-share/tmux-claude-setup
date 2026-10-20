#!/usr/bin/env bash
# Claude Code status line:
#   model · effort │ session name │ dir ⎇ branch │ ctx N% │ 5h N%
# Reads the status line JSON on stdin (see /statusline docs for the fields).

IFS=$'\x1f' read -r -d '' model effort name dir ctx limit < <(
    jq -j '[
        .model.display_name // .model.id // "?",
        .effort.level // "",
        .session_name // "",
        .workspace.current_dir // .cwd // ".",
        (.context_window.used_percentage // "" | tostring),
        (.rate_limits.five_hour.used_percentage // "" | tostring)
    ] | join("\u001f")'
)

reset=$'\e[0m' dim=$'\e[2m' bold=$'\e[1m'
cyan=$'\e[36m' green=$'\e[32m' yellow=$'\e[33m' red=$'\e[31m' magenta=$'\e[35m'
sep="${dim} │ ${reset}"

# Green below 70%, yellow below 90%, red above.
level_color() {
    if [ -z "$1" ]; then printf '%s' "$dim"
    elif [ "$1" -ge 90 ]; then printf '%s' "$red"
    elif [ "$1" -ge 70 ]; then printf '%s' "$yellow"
    else printf '%s' "$green"
    fi
}

out="${cyan}${bold}${model}${reset}"
[ -n "$effort" ] && out+="${dim} · ${effort}${reset}"
[ -n "$name" ] && out+="${sep}${magenta}${name}${reset}"

if [ "$dir" = "$HOME" ]; then short_dir="~"; else short_dir=${dir##*/}; fi
out+="${sep}${short_dir}"
branch=$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
[ -n "$branch" ] && out+=" ${dim}⎇${reset} ${branch}"

[ -n "$ctx" ] && out+="${sep}ctx $(level_color "$ctx")${ctx}%${reset}"
[ -n "$limit" ] && out+="${sep}5h $(level_color "$limit")${limit}%${reset}"

printf '%s\n' "$out"
