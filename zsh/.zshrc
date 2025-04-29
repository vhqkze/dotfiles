# shellcheck disable=SC2034,SC1090,SC1091
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${ZSH:=${XDG_DATA_HOME:=$HOME/.local/share}/oh-my-zsh}"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:=$HOME/.cache}/oh-my-zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
mkdir -p "$ZSH_CACHE_DIR/completions"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "${XDG_STATE_HOME:=$HOME/.local/state}/zsh"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$ZSH/custom"
# setopt HIST_IGNORE_ALL_DUPS

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

command_exist() {
    command -v "$@" >/dev/null 2>&1
}

if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi
if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi
if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-vi-mode" ]]; then
    git clone https://github.com/jeffreytse/zsh-vi-mode.git "${ZSH_CUSTOM}/plugins/zsh-vi-mode"
fi
if [[ ! -d "${ZSH_CUSTOM}/plugins/fast-syntax-highlighting" ]]; then
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/fast-syntax-highlighting"
fi

plugins=(
    starship
    zoxide
    zsh-autosuggestions
    fast-syntax-highlighting
    # zsh-syntax-highlighting
    zsh-vi-mode
)
if command_exist poetry; then
    poetry completions zsh > "${ZSH_CACHE_DIR}/completions/_poetry"
fi
if command_exist atuin && [[ ! -f "$(brew --prefix)/share/zsh/site-functions/_atuin" ]]; then
  atuin gen-completions --shell zsh --out-dir "${ZSH_CACHE_DIR}/completions"
fi

if command_exist rustup; then
    rustup completions zsh > "${ZSH_CACHE_DIR}/completions/_rustup"
    rustup completions zsh cargo > "${ZSH_CACHE_DIR}/completions/_cargo"
fi
if command_exist systemctl; then
    plugins+=(systemd)
fi

# plugin zsh-vi-mode configuration {{{
function zvm_config() {
    ZVM_VI_EDITOR=$EDITOR
    ZVM_VI_SURROUND_BINDKEY="s-prefix"
    ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_DEFAULT
    ZVM_INIT_MODE=sourcing
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_LAZY_KEYBINDINGS=true
    bindkey -r '^[h'
    bindkey -r '^[l'
    ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
    ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
    ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
    ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
    ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
}
# function zvm_after_init() {
#     bindkey '^[[A' up-line-or-beginning-search
#     bindkey '^[[B' down-line-or-beginning-search
#     keybindings for history autocomplete
#     [[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
#     [[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward
# }
# see: https://github.com/jeffreytse/zsh-vi-mode/issues/19
function zvm_vi_yank() {
    zvm_yank
    echo "${CUTBUFFER}" | clipcopy
    zvm_exit_visual_mode
}
# plugin zsh-vi-mode configuration }}}

# plugins need to be added before oh-my-zsh.sh is sourced
source "$ZSH/oh-my-zsh.sh"

zle_highlight+=('paste:none')

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG="en_US.UTF-8"
# export LANG="zh_CN.UTF-8"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# User configuration {{{

if [[ -d "$HOME/.config/zsh/custom" ]]; then
    for file in "$HOME"/.config/zsh/custom/*; do
        source "$file"
    done
fi

if command_exist luarocks; then
    eval "$(luarocks path --bin)"
fi

# }}}

if command_exist atuin; then
    eval "$(atuin init zsh)"
fi
