# Setting the theme
if [ -f ~/.zsh-ui-background ]; then
	export BACKGROUND=$(cat ~/.zsh-ui-background)
else
	export BACKGROUND="dark"
fi
if [ -f ~/.zsh-ui-theme ]; then
	export THEME=$(cat ~/.zsh-ui-theme)
else
	export THEME="base16-solarized"
fi

BASE16_SHELL="$DOTFILES/.config/base16-shell/$THEME.$BACKGROUND.sh"
# [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
source $BASE16_SHELL

# set the background color to light
function light() {
	\rm ~/.zsh-ui-background
    echo "light" > ~/.zsh-ui-background && reload!
}

function dark() {
	\rm ~/.zsh-ui-background
    echo "dark" > ~/.zsh-ui-background && reload!
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

