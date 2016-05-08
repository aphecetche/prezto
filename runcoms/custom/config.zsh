
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE

# history
setopt HIST_VERIFY
setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY

setopt COMPLETE_ALIASES

setopt autopushd pushdminus pushdsilent pushdtohome
