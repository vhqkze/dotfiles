(($+commands[tmux])) || return

if [[ -n "$SSH_CONNECTION" ]]; then
    CLIENT_IP=$(echo $SSH_CONNECTION | awk '{print $1}')
    LOCAL_IPS=$(hostname -I)
    # 如果客户端 IP 不在本机 IP 列表中，且不在 TMUX 中，才启动 tmux，避免在 tmux 内登录
    # 自身而重复打开 tmux 导致界面错乱
    if [[ ! " $LOCAL_IPS " =~ " $CLIENT_IP " ]] && [[ -z "$TMUX" ]]; then
        tmux attach || tmux new-session
    fi
fi

if [[ -n "$TMUX" ]]; then
    tmux_update_env() {
        eval "$(tmux showenv -s)"
    }
    preexec_functions+=(tmux_update_env)
fi
