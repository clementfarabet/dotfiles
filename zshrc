# ~/.zshrc — symlinked from the dotfiles repo (github.com/clementfarabet/dotfiles)

# ── Homebrew ────────────────────────────────────────────────────────────────
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# ── History ─────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE \
       HIST_REDUCE_BLANKS SHARE_HISTORY INC_APPEND_HISTORY

# ── General options ─────────────────────────────────────────────────────────
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS INTERACTIVE_COMMENTS NO_BEEP
export EDITOR="${EDITOR:-vim}"
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadacec

# ── Completion ──────────────────────────────────────────────────────────────
[[ -d "$BREW_PREFIX/share/zsh-completions" ]] && fpath=("$BREW_PREFIX/share/zsh-completions" $fpath)
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{magenta}-- %d --%f'
zstyle ':completion:*' group-name ''

# ── Key bindings ────────────────────────────────────────────────────────────
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search     # ↑ searches history by prefix
bindkey '^[[B' down-line-or-beginning-search   # ↓
bindkey '^[[1;3D' backward-word                # ⌥←
bindkey '^[[1;3C' forward-word                 # ⌥→

# ── Tools (each loads only if installed) ────────────────────────────────────
(( $+commands[fzf] ))    && source <(fzf --zsh)          # Ctrl-R history, Ctrl-T files
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"  # smarter cd

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8 \
  --color=info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# ── Aliases ─────────────────────────────────────────────────────────────────
if (( $+commands[eza] )); then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --git --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
else
  alias ll='ls -lah'
fi
(( $+commands[bat] )) && alias cat='bat --paging=never' && export BAT_THEME="Catppuccin Mocha"

alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'
alias reload='source ~/.zshrc && echo "zshrc reloaded"'

# ── Plugins (must be near the end; syntax-highlighting last) ───────────────
[[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

[[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ── Prompt ──────────────────────────────────────────────────────────────────
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:git:*' formats ' %F{magenta}%b%f'
  setopt PROMPT_SUBST
  PROMPT='%F{cyan}%~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '
fi

# Machine-specific overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
