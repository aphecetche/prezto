# ------------------------------------
# Docker alias and function
# ------------------------------------

# shortcut to docker-compose
alias dc="docker-compose"

# Get latest container ID
alias dl="docker ps -l -q"

# Get container process
alias dps="docker ps"

# Get process included stop container
alias dpa="docker ps -a"

# Get images
alias di="docker images"

# Show volumes
alias dv="docker volume ls"

# Remove dangling volumes
# but exclude from the purge everything starting with vc_ 
# i.e. the ones I created explicitely
drmv() {
    docker volume rm $(docker volume ls -qf dangling=true | grep -v "^vc_")
}

dvscp() {
    # copy a docker volume to another host
    #docker run --rm -v <SOURCE_DATA_VOLUME_NAME>:/from alpine ash -c "cd /from ; tar -cf - . " | ssh <TARGET_HOST> 'docker run --rm -i -v <TARGET_DATA_VOLUME_NAME>:/to alpine ash -c "cd /to ; tar -xvf - " '
}


dvolume2archive() {
    # make a tar.gz of a docker volume
    local volume_name=$1

    $(docker volume ls | grep $volume_name 2>&1 > /dev/null) \
        && \
        { 
            docker run -it --rm -v $volume_name:/data -v $(pwd):/backup alpine:3.5 tar zcvf /backup/$volume_name.tar.gz /data \
                && printf "%s\\n" "archive $volume_name.tar.gz successfully created" \
                || printf "%s\\n" "could not create archive $volume_name"
        } \
            || \
            printf "%s\\n" "volume $volume_name does not exist. Can not archive it !"
}

darchive2volume() {
    # reverse operation from dvolume2archive : take an archive and populate
    # a volume with it
    # will fail if the target volume already exist !

    local volume_name=$2

    local archive_dir=$(dirname $1)
    local archive=$(basename $1)

    $(docker volume ls | grep $volume_name > /dev/null 2>&1)

    if [ $? = 0 ]; then 
        printf "%s\\n" "volume $volume_name already exists ! will not overwrite it !"
    else
        docker run -it --rm -v $volume_name:/dest -v $archive_dir:/src alpine:3.5 tar -zxvf /src/$archive -C /dest
    fi
}

dvclone() {
    # clone a volume into another one
    # inspired from https://github.com/gdiepen/docker-convenience-scripts

    #First check if the user provided all needed arguments
    if [ "$1" = "" ]
    then
        echo "Please provide a source volume name"
        exit
    fi

    if [ "$2" = "" ] 
    then
        echo "Please provide a destination volume name"
        exit
    fi

    #Check if the source volume name does exist
    docker volume inspect $1 > /dev/null 2>&1
    if [ "$?" != "0" ]
    then
        echo "The source volume \"$1\" does not exist"
        exit
    fi

    #Now check if the destinatin volume name does not yet exist
    docker volume inspect $2 > /dev/null 2>&1

    if [ "$?" = "0" ]
    then
        echo "The destination volume \"$2\" already exists"
        exit
    fi



    echo "Creating destination volume \"$2\"..."
    docker volume create --name $2  
    echo "Copying data from source volume \"$1\" to destination volume \"$2\"..."
    docker run --rm \
        -i \
        -t \
        -v $1:/from \
        -v $2:/to \
        alpine:3.5 ash -c "cd /to ; cp -a /from/* ."

}

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

dgetmyip() {

    ip route get 8.8.8.8 | head -1 | cut -d' ' -f8
}

dxquartz_if_not_running() {
    #
    # check (and start if not running) that xquartz is
    # running (MAC OSX ONLY)
    #
    v_nolisten_tcp=$(defaults read org.macosforge.xquartz.X11 nolisten_tcp)
    v_xquartz_app=$(defaults read org.macosforge.xquartz.X11 app_to_run)

    if (( $v_nolisten_tcp == 1 )); then
        defaults write org.macosforge.xquartz.X11 nolisten_tcp 0
    fi

    if [ $v_xquartz_app != "/usr/bin/true" ]; then
        defaults write org.macosforge.xquartz.X11 app_to_run /usr/bin/true
    fi

    # test if XQuartz has to be launched
    #
    if [[ "$(launchctl list | grep startx | cut -c 1)" == "-" ]]; then
        open -a XQuartz
        sleep 2
    fi
}

docker_run_withX11() {

    # a wrapper to "docker run" to get X11 display working
    # correctly

    case "$OSTYPE" in
        darwin*)
            dxquartz_if_not_running
            ;;
    esac


    case "$OSTYPE" in
        darwin*)
            xhost +$(dgetmyip)
            docker run -e DISPLAY=$(dgetmyip):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/localtime:/etc/localtime -e TZ="Europe/Paris" $@
            ;;
        *)
            xhost + # fixme, there should be a better way...
            docker run -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/localtime:/etc/localtime -e TZ="Europe/Paris" $@
        ;;
    esac
}


alias dvm="screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty"

dexist() {
    # whether container exist or not
    
    for d in $(docker ps -q -a); do
        name=$(docker inspect -f "{{ .Name }}" $d)
        [[ "/$1" == "$name" ]] && return 0  
    done
    return 1 
}

getdirlist() {
    for par in $@; do
        abs_path=$(unset CDPATH && cd $(dirname $par) && pwd)
        if test -G $abs_path; then
            echo "$abs_path"
        fi 
    done 
}

dvim() {

	# must get a list of basedirs in order to insure we are
	# mounting them in the container

	firstdir=""
	cmd="docker run -it --rm -e BASE16_THEME=$BASE16_THEME "

	for dir in $(getdirlist $@ | sort | uniq); do
		cmd="$cmd -v $dir:$dir"
		if [ -n $firstdir ]; then
			firstdir="$dir"
			cmd="$cmd -w $firstdir"
		fi
	done

    if test -n "$DVIM_LIVEDOWN_PORT"; then
        cmd="$cmd -p $DVIM_LIVEDOWN_PORT:$DVIM_LIVEDOWN_PORT"
    fi
    if test -n "$DVIM_YCM_EXTRA_CONF"; then
        cmd="$cmd -v $DVIM_YCM_EXTRA_CONF:$HOME/.ycm_extra_conf.py"
    fi
    if test -n "$DVIM_DOCKER"; then
        # docker options passed "as is"
        cmd="$cmd $DVIM_DOCKER"
    fi

    cmd="$cmd dvim-$USER"
    for par in $@; do
        abs_path=$(cd $(dirname $par); pwd)
        cmd="$cmd $abs_path/$(basename $par)"
    done

    if test -n "$DVIM_DEBUG"; then
        echo "cmd=$cmd"
    else
        eval $cmd
    fi
	unset dir
	unset firstdir
	unset cmd
}
