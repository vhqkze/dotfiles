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
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
if [ ! -w "${XDG_RUNTIME_DIR:="/run/user/$UID"}" ]; then
    XDG_RUNTIME_DIR=/tmp
fi
export XDG_RUNTIME_DIR

# mail
export MAILRC="$HOME/.config/mail/mailrc"
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
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
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

if [[ -f "$HOME/.config/zsh/secret" ]]; then
    source "$HOME/.config/zsh/secret"
fi
