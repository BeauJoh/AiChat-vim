# Vim AiChat Plugin

A Vim plugin that integrates with [AiChat CLI](https://github.com/sigoden/aichat) to provide multi-turn AI chat directly in Vim. Designed for Vim (not Neovim) with Python support.

---

[![asciicast](https://asciinema.org/a/IGxsdeDLoTLOf4ur.svg)](https://asciinema.org/a/IGxsdeDLoTLOf4ur)

---

## Features

- **Multi-turn AI chat**: Interact with AI in a dedicated scratch buffer.
- **Visual selection support**: Highlight text in Vim and send it directly to AiChat.
- **Normal mode support**: Open an empty AiChat buffer for new prompts.
- **Scratch buffer**: No save prompts; buffer closes normally.
- **Folding**: Previous AI responses are automatically folded except the latest.
- **Highlighting**: Different colors for user prompts and AI responses.
- **Auto-scroll**: Always scrolls to the latest AI response.

---

## Usage

### Mappings

| Mode          | Mapping       | Description |
|---------------|---------------|-------------|
| Visual        | `<leader>a`   | Send selected text to a new AiChat buffer. Works for linewise, characterwise, or blockwise selection. |
| Normal        | `<leader>a`   | Open an empty AiChat buffer for a new prompt. |
| AiChat buffer | `<leader>s`   | Send the last user prompt to AiChat and append the response. |

### Commands

- `:AiChatBuf` – Open a new AiChat buffer.
- `:'<,'>AiChatBuf` – Open AiChat buffer with the selected line range (linewise only).
- `:AiChatSend` – Send the last prompt in the AiChat buffer to the AI.

---

## Installation

### Using [Vundle](https://github.com/VundleVim/Vundle.vim)

Add the following to your `.vimrc`:

```
Plugin 'BeauJoh/AiChat-vim'
```

Source or restart vim, then run:

```
:BundleInstall
````

### Requirements

Requirements

* Vim 8.2 or newer with Python support
* Python 3 (tested on Python 3.10.12)
* [AiChat CLI](https://github.com/sigoden/aichat)

**Note:** ***Installation and configuration of the AiChat CLI is required separately.***

## Local Installation & Development Setup (AiChat)

This plugin is designed to work with a locally installed instance of [AiChat](https://github.com/sigoden/aichat).
Here's how I got it up and running for development (without requiring `sudo`):

1. **Download & Extract:** Download the pre-built binary from [https://github.com/sigoden/aichat/releases](https://github.com/sigoden/aichat/releases) and extract it to a local directory (e.g., `~/.bin`).

2. **Update PATH:** Add the directory containing the `aichat` binary to your `$PATH` environment variable.  Edit your `.zshrc` or `.bashrc` file and add a line like this:

   ```bash
   export PATH=$HOME/.bin:$PATH
   ```

   *Remember to source your shell configuration file (e.g., `source ~/.zshrc` or `source ~/.bashrc`) after making this change.*

3. **Configure AiChat:** Run `aichat` in your terminal. The first time you run it, you'll be prompted to configure your AI provider.

   * **Flexibility:** AiChat supports multiple LLM providers (ChatGPT, Gemini, Claude, and potentially more!), allowing you to switch without modifying your Vim configuration or this plugin.
   * **API Keys:**  The most challenging part is usually obtaining the necessary API keys from your chosen provider.
   * **Changing Providers:** To switch providers, simply delete your AiChat configuration file (`~/.config/aichat/config.yaml`) and re-run `aichat` to configure a new provider.

---

## Contributing

This plugin was initially built as a personal productivity tool and is still under development.  I welcome contributions! 

*   **Bug Reports & Feature Requests:** Please open an issue if you encounter any problems or have ideas for improvements.
*   **Pull Requests:**  Feel free to submit a pull request with your changes.

---

## Support

If you find this plugin useful, consider [buying me a beer](link to donation/buy me a coffee) to help support its development!
Cheers [Beau](https://www.linkedin.com/in/probeauno).

```

