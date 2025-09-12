command_exist tmux || return

if [[ -n "$SSH_CONNECTION" ]]; then
    #if not inside a tmux session, and if no session is started, start a new session
    test -z "$TMUX" && (tmux attach || tmux new-session)
fi

if [[ -n "$TMUX" ]]; then
    tmux_update_env() {
        eval "$(tmux showenv -s)"
    }
    preexec_functions+=(tmux_update_env)
fi
