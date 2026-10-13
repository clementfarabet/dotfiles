# dotfiles

My macOS terminal setup: zsh + [Starship](https://starship.rs) prompt, Catppuccin Mocha everywhere, iTerm2 tweaks, tmux, vim (pathogen) and git aliases.

## Install on a new Mac

```sh
git clone --recursive https://github.com/clementfarabet/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

The installer:

- installs Homebrew (if missing), `starship`, `fzf`, `zoxide`, `eza`, `bat`, `tmux`, `ripgrep`, zsh plugins and JetBrains Mono Nerd Font
- fetches the vim plugins (git submodules)
- symlinks `zshrc` → `~/.zshrc`, `starship.toml` → `~/.config/starship.toml`, `gitignore_global` → `~/.config/git/ignore`, `tmux.conf` → `~/.config/tmux/tmux.conf`, `vimrc` → `~/.vimrc`, `vim/` → `~/.vim` (existing files are backed up)
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
| `vimrc`, `vim/bundle/` | Vim config + pathogen plugins (submodules) |
| `install.sh` | Bootstrap script |

Machine-specific overrides go in `~/.zshrc.local` / `~/.vimrc.local` (not tracked).

## Vim plugins

Loaded by [pathogen](https://github.com/tpope/vim-pathogen) from `vim/bundle/`:
sensible, fugitive, surround, commentary, repeat, sleuth, unimpaired, catppuccin, lightline, nerdtree, gitgutter, fzf.vim, polyglot, auto-pairs, tmux-navigator, ale, undotree.

Leader is `Space`. Highlights: `<leader>f` files, `<leader>/` ripgrep, `<leader>b` buffers, `<leader>n` file tree, `<leader>gs` git status, `<leader>u` undo tree, `gcc` comment, `C-h/j/k/l` move across vim splits **and** tmux panes.

```sh
# add a plugin
git submodule add --depth 1 https://github.com/<user>/<repo>.git vim/bundle/<repo>
# update all plugins
git submodule update --remote --depth 1
# remove a plugin
git rm vim/bundle/<repo>
```

## Updating

Configs are symlinked, so edit files here, then commit and push. On other machines: `git -C ~/dotfiles pull --recurse-submodules`.
