emulate -L zsh

autoload -Uz add-zle-hook-widget

# One-shot widget that clears the status message on the next keypress
if ! zle -l _copilot_clear_status 2>/dev/null; then
    _copilot_clear_status() {
        if [[ -n "$_COPILOT_CLEAR_SKIP" ]]; then
            _COPILOT_CLEAR_SKIP=
            return
        fi
        zle -M ""
        add-zle-hook-widget -d line-pre-redraw _copilot_clear_status
    }
    zle -N _copilot_clear_status
fi

typeset -g _COPILOT_SUGGEST_BUSY
typeset -g _COPILOT_CLEAR_SKIP

# Guard: ignore keypresses while already processing
if [[ -n "$_COPILOT_SUGGEST_BUSY" ]]; then
    return 0
fi

# empty current status line to avoid confusion with the "Translating with Copilot" message
zle -M ""
zle -R
# sleep for 0.05 seconds to show a small blink
sleep 0.05

local prompt="$BUFFER"

if [[ -z "$prompt" ]]; then
    zle -M "Nothing to translate 🤷"
    zle -R
    _COPILOT_CLEAR_SKIP=1
    add-zle-hook-widget line-pre-redraw _copilot_clear_status
    return 1
fi

_COPILOT_SUGGEST_BUSY=1

local copilot_key="${copilot_suggest_keybinding:-\eg}"

# Show the user that copilot is working
zle -M "Copilot: translating 🔄️..."
zle -R

# Run copilot synchronously (blocks the widget, which also prevents re-entry)
local suggestion
suggestion=$(copilot --prompt "Give me a shell command for $SHELL that does: $prompt. Output ONLY the command, no explanation, no markdown." --log-level none 2>/dev/null)

# Clean up: strip any accidental code fences or blank lines
suggestion=${suggestion//\`\`\`/}
suggestion=${suggestion##$'\n'}
suggestion=${suggestion%%$'\n'}

if [[ -n "$suggestion" ]]; then
    BUFFER="$suggestion"
    CURSOR=${#BUFFER}
    zle redisplay
    zle -M "Copilot: suggestion translated in prompt ✅ Edit as needed or press enter to run."
    _COPILOT_CLEAR_SKIP=1
    add-zle-hook-widget line-pre-redraw _copilot_clear_status
else
    zle -M "Copilot: no suggestion received"
    zle -R
fi

# Drain any keystrokes that accumulated in the terminal buffer while copilot ran.
# Without this, zle reads the buffered bytes after we return and retriggers the widget.
while read -rs -t 0 -k 1 2>/dev/null; do : ; done

# Rebind and unlock
bindkey "$copilot_key" copilot-suggest
_COPILOT_SUGGEST_BUSY=
return 0
