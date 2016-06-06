# ------------------------------------
# Docker alias and function
# ------------------------------------

# Get latest container ID
alias dl="docker ps -l -q"

# Get container process
alias dps="docker ps"

# Get process included stop container
alias dpa="docker ps -a"

# Get images
alias di="docker images"

# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"

# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"

# Stop all containers
dstop() { docker stop $(docker ps -a -q); }

# Remove all containers
drma() { docker rm $(docker ps -a -q); }

# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Remove all images
drmia() { docker rmi $(docker images -q); }

# Remove untagged images
drmi() {
    docker rmi $(docker images | grep "<none>" | awk '{print $3}')
}

# Dockerfile build, e.g., $dbu tcnksm/test 
dbu() { docker build -t=$1 .; }

# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# remove stopped containers
drm() {
    docker rm $(docker ps -q -f status=exited)
}

getmyip() { 
    ifconfig en3 2> /dev/null | grep --color=auto inet | awk '$1=="inet" {print $2}' && ifconfig en0 2> /dev/null | grep --color=auto inet | awk '$1=="inet" {print $2}'
}

xquartz_if_not_running() {
    v_nolisten_tcp=$(defaults read org.macosforge.xquartz.X11 nolisten_tcp)
    v_xquartz_app=$(defaults read org.macosforge.xquartz.X11 app_to_run)

    if (( $v_nolisten_tcp == 1 )); then
        defaults write org.macosforge.xquartz.X11 nolisten_tcp 0
    fi

    if [ $v_xquartz_app != "/usr/bin/true" ]; then
        defaults write org.macosforge.xquartz.X11 app_to_run /usr/bin/true
    fi

    # test if XQuartz has to be launched

    if [[ "$(launchctl list | grep startx | cut -c 1)" == "-" ]]; then
        open -a XQuartz
        sleep 2
        xhost + $(getmyip)
    fi
}

drunx11() {
    xquartz_if_not_running 
    docker run -e DISPLAY=$(getmyip):0 -v /tmp/.X11-unix:/tmp/.X11-unix $@
}

alias dvm="screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty"

dexist() {
    # whether container exist or not
    for d in $(docker inspect -f "{{ .Name }}" $(docker ps -q -a)); do
        [[ "/$1" == "$d" ]] && return 0  
    done
    return 1 
}

