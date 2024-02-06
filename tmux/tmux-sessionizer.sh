#!/usr/bin/env bash

search_dirs=(
    "/Volumes/Transcend/Developer/git/main-projects"
    "/Volumes/Transcend/Developer/git/side-projects"
    "/Volumes/Transcend/Developer/projects"
    "/Users/maciej/Library/Group Containers/G69SCX94XU.duck/Library/Application Support/duck/Volumes.noindex/Nextcloud/documents/obsidian"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "${search_dirs[@]}" ~/ -maxdepth 2 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$selected_name"
else
    tmux attach-session -t "$selected_name"
fi
