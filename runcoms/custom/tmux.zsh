
tmux_start()
{
    if [ "$(uname)" = "Darwin" ]; then
        export TMUX_HOST_ICON=''
    else
        export TMUX_HOST_ICON=''
    fi
    tmux -2
}
