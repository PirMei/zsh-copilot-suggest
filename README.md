# zsh-copilot-suggest

A zimfw plugin that integrates the GitHub Copilot CLI binary directly with your zsh shell, allowing you to translate natural language prompts into shell commands instantly.

## Features

- Keybinding to translate current shell prompt using Copilot
- Natural language input gets replaced with suggested command
- Prevents accidental double-triggers by locking during generation
- Easy to accept, edit, or cancel suggestions
- Works with the standalone `copilot` binary

## Prerequisites

- [GitHub Copilot CLI](https://docs.github.com/en/copilot/copilot-in-the-cli/about-github-copilot-in-the-cli) installed
  - Verify: `which copilot` should return a path
  - Authenticate: `copilot auth login` to authenticate with GitHub

## Installation

### With zimfw

Add to your `.zimrc`:

```zsh
zmodule PirMei/zsh-copilot-suggest
```

Then run:

```zsh
zimfw install
```

### Manual Installation (without zimfw)

1. Clone the repository:

   ```bash
   git clone https://github.com/PirMei/zsh-copilot-suggest ~/.config/zsh/plugins/    zsh-copilot-suggest
   ```

2. Add to your `.zshrc`:

   ```zsh
   source ~/.config/zsh/plugins/zsh-copilot-suggest/init.zsh
   ```

3. Reload your shell:

   ```bash
   source ~/.zshrc
   ```

## Usage

### Basic Workflow

1. Type your natural language description in the shell prompt

   ```plain
   user@home$ find all python files in current directory
   ```

2. Press **Alt+G** (default keybinding)

3. The shell prompt content is sent to Copilot and replaced with the suggested command

   ```plain
   user@home$ find . -name "*.py" -type f
   ```

4. Press Enter to execute, or edit the command further before executing

## Configuration

### Keybinding

Customize your keybinding by adding this to your `.zshrc` **before** sourcing the plugin:

```zsh
# Alt+G (default)
copilot_suggest_keybinding="\eg"
```

For more keycodes check the [zle docs](https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins-1).

Then source the plugin:

```zsh
source zsh-copilot-suggest/init.zsh
```

## How It Works

1. You type a natural language description: `find all python files in current directory`
2. You press the keybinding (default: Alt+G)
3. The plugin sends your text to the `copilot` binary
4. Copilot interprets the natural language and returns a shell command
5. The shell prompt is replaced with the suggested command leveraging ZSH line editor (ZLE) functionality
6. You can press Enter to execute, or edit the command first

## License

MIT
