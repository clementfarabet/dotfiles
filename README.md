# dotfiles

My macOS terminal setup: zsh + [Starship](https://starship.rs) prompt, Catppuccin Mocha everywhere, iTerm2 tweaks, and git aliases.

## Install on a new Mac

```sh
git clone https://github.com/clementfarabet/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

The installer:

- installs Homebrew (if missing), `starship`, `fzf`, `zoxide`, `eza`, `bat`, zsh plugins and JetBrains Mono Nerd Font
- symlinks `zshrc` → `~/.zshrc`, `starship.toml` → `~/.config/starship.toml`, `gitignore_global` → `~/.config/git/ignore` (existing files are backed up)
- adds `gitconfig` to `~/.gitconfig` via `[include]` (your identity and other settings are left alone)
- downloads the Catppuccin Mocha iTerm2 color scheme and sets the **Minimal** iTerm theme

It's safe to re-run. Then in iTerm2 → Settings → Profiles: pick the `catppuccin-mocha` color preset and the `JetBrainsMono Nerd Font` font.

## What's inside

| File | Purpose |
|---|---|
| `zshrc` | History, completion, keybindings, aliases, plugins, prompt |
| `starship.toml` | Two-line Catppuccin prompt |
| `gitconfig` | Git aliases (`git aliases` lists them) + sane defaults |
| `gitignore_global` | macOS / editor junk |
| `tmux.conf` | tmux with `C-o` prefix, `\|`/`-` splits, `hjkl` panes, Catppuccin status bar |
| `install.sh` | Bootstrap script |

Machine-specific shell settings go in `~/.zshrc.local` (not tracked).

## Updating

Configs are symlinked, so edit files here, then commit and push. On other machines: `git -C ~/dotfiles pull`.
