#!/bin/sh
# Path to your TODO file
TODO_FILE="$HOME/documents/.bc/batcave/TODO/$(bemenu-input)-todo.md"

# Convert Markdown headers to colored Pango markup
FORMATTED_CONTENT=$(cat "$TODO_FILE" |
    sed -E "s/^# ([^#].*)/<span foreground='#a7c080' size='x-large'><b>\1<\/b><\/span>/g" |
    sed -E "s/^## ([^#].*)/<span foreground='#ed8796' size='large'><b>\1<\/b><\/span>/g" |
    sed -E "s/^### ([^#].*)/<span foreground='#b7bdf8'><b>\1<\/b><\/span>/g")

# Send to SwayNC
notify-send "" "$FORMATTED_CONTENT"
