
alias ll='ls -al'

alias token='alien-token-init laphecet'

alias rh='cat $HOME/.root_hist'

alias locate='mdfind -name'

alias dox='source $HOME/Scripts/alice-doxygen.sh'

alias vaf='ssh laphecet@localhost -p 5522 -Y'

alias gssh='gsissh -p 1975'

alias gscp='gsiscp -S `which gsissh` -P 1975'

alias saf3-enter='source $HOME/Scripts/saf3.sh enter'
alias saf3='source $HOME/Scripts/saf3.sh'

alias o2-dev='. ~/github.com/aphecetche/docker-alice-dev/init.sh'

alias cvmfs='source $HOME/Scripts/cvmfs.sh'

alias ks='screen -ls | grep -o "[0-9]\{5\}" | awk "{print $1}"| xargs -I{} screen -S {} -X quit'

alias dhcp-start='sudo /bin/launchctl load -w /System/Library/LaunchDaemons/bootps.plist'

alias dhcp-stop='sudo /bin/launchctl unload -w /System/Library/LaunchDaemons/bootps.plist'

alias alienv="alienv -w $HOME/alice/sw"

alias root5="alienv enter ROOT/latest-ali-master-release --shellrc"
alias root6="alienv enter ROOT/latest-o2-ref-o2 --shellrc"
alias alireco="alienv enter AliRoot/latest-ali-reco-2017-release --shellrc"

alias aliphysics="alienv enter AliPhysics/latest-ali-physics-master-release --shellrc"
