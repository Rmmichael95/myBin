#!/bin/bash
# Path to your TODO dir
TODO_DIR="$HOME/documents/.bc/batcave/TODO/"
FINAL_CONTENT=""

# Loop through every file in the directory
for file in "$TODO_DIR"/*; do
    # Convert Markdown headers to colored Pango markup
    FORMATTED_FILE=$(cat "$file" |
        sed -E "s/^# ([^#].*)/<span foreground='#a7c080' size='x-large'><b>\1<\/b><\/span>/g" |
        sed -E "s/^## ([^#].*)/<span foreground='#ed8796' size='large'><b>\1<\/b><\/span>/g" |
        sed -E "s/^### ([^#].*)/<span foreground='#b7bdf8'><b>\1<\/b><\/span>/g")

    # Append to the final notification body
    FINAL_CONTENT+="$FORMATTED_FILE\n\n"
done

# Send the combined notification
notify-send "" "$FINAL_CONTENT"
