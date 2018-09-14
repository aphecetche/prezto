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
# assuming this one has been installed in iTerm2, that is ;-)
function change_theme() {
    it2prof $1
    #TODO : find out of to change VSCode theme from outside VSCode ?
}

function day() {
    change_theme unikitty-light
}

function night() {
    change_theme tomorrow-night
}

export GREP_COLOR="30;43"
export GREP_COLORS="mt=30;43"

