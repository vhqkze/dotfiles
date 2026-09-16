#!/usr/bin/env zsh

# https://zsh.sourceforge.io/Doc/Release/Files.html
# Startup:
#   /etc/zshenv
#   $ZDOTDIR/.zshenv
#   /etc/zprofile (if login shell)
#   $ZDOTDIR/.zprofile (if login shell)
#   /etc/zshrc (if interactive)
#   $ZDOTDIR/.zshrc (if interactive)
#   /etc/zlogin (if login shell)
#   $ZDOTDIR/.zlogin (if login shell)
#
# Shutdown: (This happens with either an explicit exit via the exit or logout commands, or an implicit exit by reading end-of-file from the terminal.)
#   $ZDOTDIR/.zlogout
#   /etc/zlogout
#
# If ZDOTDIR is unset, HOME is used instead.

# xdg
# see: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
if [ ! -w "${XDG_RUNTIME_DIR:="/run/user/$UID"}" ]; then
    XDG_RUNTIME_DIR="/tmp/user-$UID-runtime"
    [[ -d "$XDG_RUNTIME_DIR" ]] || mkdir -p -m 0700 "$XDG_RUNTIME_DIR"
fi
export XDG_RUNTIME_DIR

# oh-my-zsh
export ZSH="${ZSH:-$XDG_DATA_HOME/oh-my-zsh}"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
export ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-$XDG_CACHE_HOME/oh-my-zsh}"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-${ZSH_VERSION}"

[[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"
[[ -d "$ZSH_CUSTOM" ]] || mkdir -p "$ZSH_CUSTOM"

# mail
export MAILRC="$XDG_CONFIG_HOME/mail/mailrc"
# gpg
GPG_TTY=$(tty)
export GPG_TTY
# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
# jupyter
export JUPYTER_CONFIG_DIR="$XDG_DATA_HOME/jupyter"
# ipython
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
# pipx
export PIPX_HOME="$XDG_DATA_HOME/pipx"
# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
# go
export GOPATH="$XDG_DATA_HOME/go"
export GOPROXY=https://proxy.golang.com.cn,direct
# gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
# android
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
# deno
export DENO_INSTALL_ROOT="$XDG_DATA_HOME/deno"
export PATH="$DENO_INSTALL_ROOT/bin:$PATH"
# python
export PYTHONPATH=".:$PYTHONPATH"
# ruby
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
# sqlite
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"
# less
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
[[ -d "$XDG_STATE_HOME/less" ]] || mkdir -p "$XDG_STATE_HOME/less"

# ansible
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible"

# zoxide
export _ZO_ECHO=1

# path
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$CARGO_HOME/bin"
# remove duplication
typeset -U path

# other
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man! -c "set statuscolumn=" -c "set signcolumn=no" -c "set scrolloff=999" --'

if [[ -f "$XDG_CONFIG_HOME/zsh/secret" ]]; then
    source "$XDG_CONFIG_HOME/zsh/secret"
fi

# nixos, home-manager, home.sessionVariables
if [[ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]]; then
    source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
fi
