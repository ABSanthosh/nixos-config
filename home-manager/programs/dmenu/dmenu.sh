#!/bin/bash

# Dependencies: fzf, qalc, dmenu_path
# Ensure they're installed
command -v fzf >/dev/null 2>&1 || { echo "fzf is required but not installed."; exit 1; }
command -v qalc >/dev/null 2>&1 || { echo "qalc is required but not installed."; exit 1; }
command -v dmenu_path >/dev/null 2>&1 || { echo "dmenu_path is required but not installed."; exit 1; }

# Function to evaluate math expression with qalc
evaluate_math() {
    local input="$1"
    # Remove '>' and trim whitespace
    expr=$(echo "$input" | sed 's/^>//' | xargs)
    if [ -n "$expr" ]; then
        # Use qalc to calculate, suppress interactive prompt
        result=$(qalc -t "$expr" 2>/dev/null)
        if [ $? -eq 0 ]; then
            echo "Result: $result"
        else
            echo "Invalid expression"
        fi
    else
        echo ""
    fi
}

# Main launcher function
launcher() {
    # Get list of applications from dmenu_path
    apps=$(dmenu_path | sort -u)

    # Initialize input
    input=""
    prompt="Launcher (> for math): "

    while true; do
        # Clear screen for clean display
        clear

        # Display math preview if input starts with '>'
        if [[ "$input" =~ ^\> ]]; then
            math_result=$(evaluate_math "$input")
            echo -e "Math Preview:\n$math_result\n"
        else
            # Show app suggestions
            echo -e "Applications:\n$apps" | grep -i "$input" | head -n 10
        fi

        # Display prompt and input
        echo -n "$prompt"
        echo "$input"

        # Read a single character without pressing enter
        read -n 1 -s char

        case "$char" in
            $'\x7f') # Backspace
                input="${input%?}"
                ;;
            $'\n') # Enter
                if [[ "$input" =~ ^\> ]]; then
                    # If math mode, display final result and exit
                    final_result=$(evaluate_math "$input")
                    clear
                    echo "Final Result: $final_result"
                    read -p "Press Enter to exit..."
                    exit 0
                elif [ -n "$input" ]; then
                    # If app mode, launch app and exit
                    if echo "$apps" | grep -Fx "$input" >/dev/null; then
                        exec "$input" &
                        exit 0
                    else
                        clear
                        echo "Application '$input' not found."
                        read -p "Press Enter to continue..."
                        input=""
                    fi
                fi
                ;;
            $'\e') # Escape
                exit 0
                ;;
            *)
                input="$input$char"
                ;;
        esac
    done
}

# Run fzf to filter apps or handle input
launcher | fzf --prompt="Launcher (> for math): " --preview-window=up:30% --preview="echo {}"