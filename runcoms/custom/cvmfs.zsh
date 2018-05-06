#!/bin/sh

cvmfs_repo() {

    [ ! -d /cvmfs/$1 ] && sudo mkdir -p /cvmfs/$1
    sudo mount -t cvmfs $1 /cvmfs/$1

}

cvmfs_alice_repos() {
# add more cvmfs repositories if you need below _without_ the starting /cvmfs

cvmfs_repos="alice.cern.ch alice-ocdb.cern.ch alice-nightlies.cern.ch sft.cern.ch sft-nightlies.cern.ch"

# sudo cvmfs_config umount

for repos in `echo ${cvmfs_repos} |tr "," "\n"`; do
    cvmfs_repo $repos
done

}
