#!/bin/bash

# App launcher with fzf and dmenu_path
# Supports math mode: type ">" followed by math expression for live preview of result
# On enter:
# - If query starts with ">", compute math with bc and copy result to clipboard (requires xclip)
# - Else, launch the selected app

# Get list of apps
apps=$(dmenu_path)

# Run fzf with print-query and preview
result=$(echo "$apps" | fzf --print-query \
  --preview='query={q}; if [[ $query == ">"* ]]; then expr="${query#>}"; echo "$expr = $(echo "$expr" | bc -l 2>/dev/null || echo "Invalid expression")"; else echo "Select to launch"; fi' \
  --preview-window=up:30% \
  --prompt="Launch or >math: ")

# Extract query and selected (if any)
query=$(echo "$result" | head -n1)
selected=$(echo "$result" | tail -n +2)

# If query starts with ">", compute math
if [[ $query == ">"* ]]; then
  expr="${query#>}"
  math_result=$(echo "$expr" | bc -l 2>/dev/null)
  if [ -n "$math_result" ]; then
    echo -n "$math_result" | xclip -selection clipboard
    echo "Result copied to clipboard: $math_result"
  else
    echo "Invalid math expression"
  fi
elif [ -n "$selected" ]; then
  # Launch the selected app
  exec "$selected"
fi