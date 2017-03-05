# Setting the theme

# PURE_GIT_SYMBOL="  "
# PURE_GIT_UP_ARROW="  "
# PURE_GIT_DOWN_ARROW="  "

# Change iTerm2 color profile from the CLI
function it2prof() { 
    if [ "$(uname)" = "Darwin" ]; then
        sequence="\033]1337;SetProfile=$1\a"

        if [ -n "$TMUX" ]; then
            # Tell tmux to pass the escape sequences through
            # see e.g. http://linsam.homelinux.com/tmux/tmuxcodes.pdf
            sequence="\033Ptmux;\033$sequence\033\\"
        fi
        echo -e $sequence
    fi
}

# print available colors and their numbers
function colours() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}m colour${i}"
        if (( $i % 5 == 0 )); then
            printf "\n"
        else
            printf "\t"
        fi
    done
}

# change the (base16) theme 
# must give the name of the theme without the base16- prefix
function change_theme() {
    if [ $# -gt 0 ]; then
        theme=$1
    else
        theme="$(basename $(readlink $HOME/.base16_theme))"
        theme=${theme/base16-/}
        theme=${theme/.sh/}
    fi
    . $HOME/dotfiles/base16-shell/scripts/base16-$theme.sh
    \ln -sf $HOME/dotfiles/base16-shell/scripts/base16-$theme.sh $HOME/.base16_theme
    # change Xresources 
    test -f $HOME/.Xresources.d/base16-$theme && xrdb -merge $HOME/.Xresources.d/base16-$theme
    test -f $HOME/dotfiles/config/tmux/base16-$theme.sh && . $HOME/dotfiles/config/tmux/base16-$theme.sh
    # reload tmux configuration if under tmux
    if test -n "$TMUX"; then
        tmux source ~/.tmux.conf
    fi
}
