
alias ll='ls -al'

alias token='alien-token-init laphecet'

alias rh='cat $HOME/.root_hist'

alias locate='mdfind -name'

alias dox='source $HOME/Scripts/alice-doxygen.sh'

alias cvmfs='source $HOME/Scripts/cvmfs.sh'

alias ks='screen -ls | grep -o "[0-9]\{5\}" | awk "{print $1}"| xargs -I{} screen -S {} -X quit'

alias dhcp-start='sudo /bin/launchctl load -w /System/Library/LaunchDaemons/bootps.plist'

alias dhcp-stop='sudo /bin/launchctl unload -w /System/Library/LaunchDaemons/bootps.plist'
 
