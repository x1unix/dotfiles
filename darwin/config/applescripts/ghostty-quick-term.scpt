tell application "Ghostty"
    set term to focused terminal of selected tab of front window
    perform action "toggle_quick_terminal" on term
end tell
