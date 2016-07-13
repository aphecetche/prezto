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

BASE16_SHELL="$DOTFILES/base16-shell/$THEME.$BACKGROUND.sh"
# [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
source $BASE16_SHELL

# set the background color to light
function light() {
	\rm ~/.zsh-ui-background
	echo "light" > ~/.zsh-ui-background && reload!
	# if grep -q "set nonumber" ~/.vimrc;then
	# 	echo "vimrc has nonumber"
	# 	sed -i '' s/"set nonumber"/"set number"/ ~/dotfiles/config/nvim/init.vim
	# elif grep -q "set number" ~/.vimrc;then
	# 	echo "vimrc has number"
	# 	sed -i '' s/"set number"/"set nonumber"/ ~/dotfiles/config/nvim/init.vim
	# fi
	if [[ -n "$TMUX" ]]; then
	tmux set-environment -g BACKGROUND $BACKGROUND
	tmux set-environment -g THEME $THEME
	tmux source-file ~/.tmux.conf
	fi
    if [[ -n "$ITERM_SESSION_ID" ]]; then
        osascript <<-EOF
        tell application "iTerm"
	      tell current session of first window
            set background image to (system attribute "HOME") & "/Pictures/Terminal Backgrounds/hi tech texture.solarized.light.2.jpg"
	      end tell
        end tell
EOF
    fi
}

function dark() {
	\rm ~/.zsh-ui-background
    echo "dark" > ~/.zsh-ui-background && reload!
	if [[ -n "$TMUX" ]]; then
	  tmux set-environment -g BACKGROUND $BACKGROUND
	  tmux set-environment -g THEME $THEME
	  tmux source-file ~/.tmux.conf 
	fi
    if [[ -n "$ITERM_SESSION_ID" ]]; then
        osascript <<-EOF
        tell application "iTerm"
	      tell current session of first window
          set background image to (system attribute "HOME") & "/Pictures/Terminal Backgrounds/hi tech texture.solarized.dark.jpg"
          end tell
        end tell
EOF
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

