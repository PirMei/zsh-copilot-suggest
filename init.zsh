#!/bin/zsh
# zsh-copilot-suggest - GitHub Copilot CLI binary integration for zsh
#
# This plugin provides a keybinding to translate natural language shell prompts
# into actual commands using the GitHub Copilot CLI binary.

# Check if copilot binary is available
if ! command -v copilot &> /dev/null; then
    print "Warning: 'copilot' binary not found in PATH." >&2
    print "  Install from: https://github.com/github/github-cli" >&2
    print "  Or check your installation: which copilot" >&2
    return 1
fi

# Source functions from the functions directory
fpath=("${0:h}/functions" $fpath)
autoload -Uz copilot-suggest.zsh

# Set default keybinding if not already set
: ${copilot_suggest_keybinding:="\eg"}

# Create the zle widget
zle -N copilot-suggest copilot-suggest.zsh

# Bind the keybinding to the widget
bindkey "$copilot_suggest_keybinding" copilot-suggest
