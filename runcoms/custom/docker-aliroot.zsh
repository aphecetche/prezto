#
# some utility functions to work with AliRoot containers
#

ali_start_container() {

    # start a detached aliroot container, in x11 mode
    #
    # on input a number of bind mounted directories (ro) :
    # - .globus to get the certificate for alien-token-init
    # - alidist to get the build recipes
    # - $what (either AliRoot or AliPhysics) to get the relevant source code
    # - repos/$what as the previous one is a worktree from this one
    #
    # on "output" a single docker-managed volume containing the build
    # and install directories (vc_run2_sw)
    # (where vc_ denotes a Volume Container)
    #

    local run=$1
    local what=$2
    local whatlc=$what:l
    local version=$3
    shift 3

    docker_run_withX11 --interactive --tty --detach \
        --name "$whatlc-$version" \
        --env "ALI_WHAT=$what" \
        --env "ALI_VERSION=$version" \
        --hostname "$version" \
        --volume vc_${run}_sw:/alicesw/sw \
        --volume $HOME/.globus:/root/.globus:ro \
        --volume $HOME/alicesw/$run/$whatlc-$version/alidist:/alicesw/alidist:ro \
        --volume $HOME/alicesw/$run/$whatlc-$version/$what:/alicesw/${what}:ro \
        --volume $HOME/alicesw/repos/$what:$HOME/alicesw/repos/${what}:ro \
        $@ \
        aphecetche/centos7-ali-core 

}

ali_setup_tmux() {

    # setup, if it does not exist yet, a $whatlc-$version window
    # in the current tmux session with the following layout :
    #
    # ---------------------------------------
    # |                  |                  |
    # |                  |                  |
    # |                  | build dir in     |
    # |                  | docker container |
    # |                  | (pane 2)         |
    # |                  |                  |
    # |  local dir       |-------------------
    # |  (pane 1)        |                  |
    # |                  | exec dir in      |
    # |                  | docker container |
    # |                  | (pane 3)         |
    # |                  |                  |
    # ---------------------------------------
    #

    local run=$1
    local what=$2
    local whatlc=$what:l
    local version=$3
    local dir=$HOME/alicesw/$run/$whatlc-$version
    local wname=$whatlc-$version
    local pane_localedit=1
    local pane_build=2
    local pane_exec=3

    tmux new-window -n $wname
    tmux split-window -h -t $wname 
    tmux split-window -v -t $wname.2

    tmux send-keys -t $wname.$pane_exec "cd $dir; docker exec -it $wname /bin/bash" enter
    tmux send-keys -t $wname.$pane_build "cd $dir; docker exec -it $wname /bin/bash" enter
    tmux send-keys -t $wname.$pane_localedit "cd $dir/$what" enter

    tmux send-keys -t $wname.$pane_build "cd /alicesw/sw/BUILD/$what-latest-$version/$what" enter

    for pane in 1 2 3; do
        tmux send-keys -t $wname.$pane "clear" enter
    done

    tmux send-keys -t $wname.$pane_build "pwd" enter
}

ali_docker() {
    #
    # run a container with the source locally on the Mac
    # and the build/install in a managed docker container
    # 
    run=${1:="run2"}

    what=${2:="AliRoot"}

    whatlc=$what:l

    version=${3:="feature-reco-2016"}

    shift 3

    if ! test -d $HOME/alicesw/$run/$whatlc-$version/$what; then
        echo "Directory $HOME/alicesw/$run/$whatlc-$version/$what does not exists !"
        echo "The directories I know of in $run are :"
        ls -d $HOME/alicesw/$run/*
        return
    fi

    if ! dexist "$whatlc-$version"; then
        # start a new container 
        echo "trailing arguments passed as is : $@"
        ali_start_container $run $what $version $@
        sleep 2
    fi

    # setup the tmux layout if needed
    if [[ $TMUX ]]; then
        ali_setup_tmux $run $what $version
    else
        # simply connect to the container
        docker exec -it $whatlc-$version /bin/bash
    fi
}

ali_cvmfs() {

    # first argument (required) is the XXX::VVV string to be used
    # to issue the "alienv enter XXX::VVV" command at the
    # container startup
    #
    # remaining arguments are passed to the docker command itself
    # and can be used e.g. to bind mount more volumes
    #
    version=$1
    if [ $# -gt 0 ]; then
        shift
    fi

docker_run_withX11 --rm --interactive --tty --privileged -v $HOME/.globus:/root/.globus -v $HOME/.rootrc:/root/.rootrc $@ aphecetche/centos7-ali-cvmfs $version

}

ali_root6() 
{
    docker_run_withX11 --env "ALI_WHAT=ROOT" --env "ALI_VERSION=dev-o2-daq" --interactive --tty --volume vc_run3_sw:/alicesw/sw $@ aphecetche/centos7-ali-core
}
