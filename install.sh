#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Homebrew
if ! command -v brew >/dev/null && [[ ! -x /opt/homebrew/bin/brew ]]; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Tools + font
echo "==> Installing packages"
brew install starship zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
             fzf zoxide eza bat tmux
brew install --cask font-jetbrains-mono-nerd-font

# 3. bat theme
BAT_THEMES="$(bat --config-dir)/themes"
mkdir -p "$BAT_THEMES"
curl -fsSL -o "$BAT_THEMES/Catppuccin Mocha.tmTheme" \
  "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
bat cache --build >/dev/null

# 4. iTerm2 color scheme (downloaded; opening it imports into iTerm)
curl -fsSL -o "$DIR/catppuccin-mocha.itermcolors" \
  "https://raw.githubusercontent.com/catppuccin/iterm/main/colors/catppuccin-mocha.itermcolors"

# 5. Symlink configs (back up existing files)
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "$dst.backup.$(date +%s)"
    echo "    backed up $dst"
  fi
  ln -sfn "$src" "$dst"
  echo "    linked $dst -> $src"
}
echo "==> Linking configs"
link "$DIR/zshrc" "$HOME/.zshrc"
link "$DIR/starship.toml" "$HOME/.config/starship.toml"
link "$DIR/gitignore_global" "$HOME/.config/git/ignore"
link "$DIR/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# Include shared gitconfig without touching existing settings in ~/.gitconfig
if ! git config --global --get-all include.path 2>/dev/null | grep -qxF "$DIR/gitconfig"; then
  git config --global --add include.path "$DIR/gitconfig"
  echo "    added include of $DIR/gitconfig to ~/.gitconfig"
fi
if [[ -z "$(git config --global user.name || true)" ]]; then
  echo "    ⚠️  set your identity: git config --global user.name 'Your Name'"
  echo "                          git config --global user.email you@example.com"
fi

# 6. iTerm2 "Minimal" theme: title bar/tabs blend with the background
#    (4=Automatic, 5=Minimal, 6=Compact). iTerm overwrites prefs on quit,
#    so this only sticks if iTerm isn't running — otherwise set it in the UI.
defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5

open "$DIR/catppuccin-mocha.itermcolors" || true

cat <<'EOF'

✅ Done! Finish up in iTerm2 → Settings:
   • Appearance → General → Theme → "Minimal" (blended title bar)
   Then Profiles → your profile:
   • Colors → Color Presets… → "catppuccin-mocha"
   • Text   → Font → "JetBrainsMono Nerd Font", size 14
   • Window → Transparency ~5–10%, Blur on (optional)
   • Keys   → Key Mappings → Presets → "Natural Text Editing" (⌥←/⌥→ word jumps)
Then open a new tab (or run: exec zsh)
EOF
