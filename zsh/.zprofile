if [[ "$(uname)" == "Darwin" ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
        if [[ -x "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        if [[ -x "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
fi

if [[ -f "$HOME/.orbstack/shell/init.zsh" ]]; then
    # shellcheck disable=SC1091
    source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null
fi
