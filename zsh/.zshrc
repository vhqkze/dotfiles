# shellcheck disable=SC2034,SC1090,SC1091
export HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"

ZSH_THEME=""
zstyle ':omz:update' mode reminder # just remind me to update when it's time
zstyle ':omz:update' frequency 13
DISABLE_MAGIC_FUNCTIONS="true"

fpath=("$ZSH_CACHE_DIR/completions" $fpath)

ensure_completion() {
    local cmd="$1"
    local comp_cmd="$2"
    local comp_file="$ZSH_CACHE_DIR/completions/_$cmd"
    if ((!$+commands[$cmd])); then
        [[ -f "$comp_file" ]] && rm -f "$comp_file"
        return
    fi
    # 检查 Homebrew 或系统其他 fpath 目录中是否已自带该补全
    local exclude_dir=("$ZSH_CACHE_DIR/completions")
    local other_fpath=(${fpath:|exclude_dir})
    local -a matches
    # shellcheck disable=SC1036
    matches=($^other_fpath/_$cmd(N))
    if (($#matches > 0)); then
        [[ -f "$comp_file" ]] && rm -f "$comp_file"
        return
    fi
    # 获取二进制程序的真实物理路径（:A 修饰符会自动解析所有软链接）
    local real_bin="${commands[$cmd]:A}"
    # 触发重新生成的两个条件：
    # 1. 补全文件不存在
    # 2. 软件更新了（真实二进制文件的修改时间比补全文件更新: -nt）
    if [[ ! -f "$comp_file" ]] || [[ "$real_bin" -nt "$comp_file" ]]; then
        echo "正在为 $cmd 生成/更新 zsh 补全..."
        eval "$comp_cmd" >"$comp_file" 2>/dev/null

        # # 这一段不需要，oh-my-zsh.sh 里会加载
        # # 如果生成成功，刷新当前 zsh session 对该补全函数的加载定义
        # if [[ -s "$comp_file" ]]; then
        #     autoload -Uz "_$cmd" 2>/dev/null
        # else
        #     # 避免生成空文件导致下次依然失效
        #     rm -f "$comp_file"
        # fi
    fi
}

# 对于不是通过包管理器安装的软件，自动生成补全文件
ensure_completion "poetry" "poetry completions zsh"
ensure_completion "rustup" "rustup completions zsh"
ensure_completion "cargo" "rustup completions zsh cargo"

if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
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
)
if (($+commands[systemctl])); then
    plugins+=(systemd)
fi
plugins+=(
    zsh-autosuggestions
    fast-syntax-highlighting
    zsh-vi-mode
)

# plugin zsh-vi-mode configuration {{{
function zvm_config() {
    ZVM_VI_EDITOR=$EDITOR
    ZVM_VI_SURROUND_BINDKEY="s-prefix"
    ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_DEFAULT
    ZVM_INIT_MODE=sourcing
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_LAZY_KEYBINDINGS=true
    ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
    ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
    ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
    ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
    ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
    ZVM_SYSTEM_CLIPBOARD_ENABLED=true
}
# plugin zsh-vi-mode configuration }}}

# plugins need to be added before oh-my-zsh.sh is sourced
source "$ZSH/oh-my-zsh.sh"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

zle_highlight+=('paste:none')

# shellcheck disable=SC1073,SC1072
() {
    local file
    for file in "$XDG_CONFIG_HOME"/zsh/custom/*.zsh(N); do
        source "$file"
    done
}

if (($+commands[luarocks])); then
    eval "$(luarocks path --bin)"
fi

if (($+commands[atuin])); then
    eval "$(atuin init zsh)"
fi
