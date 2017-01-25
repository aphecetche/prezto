# Setting the theme

# BASE16_SHELL="$DOTFILES/base16-shell/scripts/$THEME.sh"
# # [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
# if ! [ -n "$ITERM_SESSION_ID" ]; then
#     source $BASE16_SHELL
# fi

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

