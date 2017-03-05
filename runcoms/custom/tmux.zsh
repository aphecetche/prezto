
tmux_start()
{
    if [ "$(uname)" = "Darwin" ]; then
        export TMUX_HOST_ICON=''
    else
        export TMUX_HOST_ICON=''
    fi
    change_theme $1
    tmux -2
}
