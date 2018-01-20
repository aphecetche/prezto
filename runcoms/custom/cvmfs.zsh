#!/bin/sh

cvmfs_alice() {
# add more cvmfs repositories if you need below _without_ the starting /cvmfs

#cvmfs_repos="atlas.cern.ch,atlas-condb.cern.ch,sft.cern.ch"
cvmfs_repos="alice.cern.ch alice-ocdb.cern.ch alice-nightlies.cern.ch"

# sudo cvmfs_config umount

for repos in `echo ${cvmfs_repos} |tr "," "\n"`; do
   [ ! -d /cvmfs/${repos} ] && sudo mkdir -p /cvmfs/${repos}
   sudo mount -t cvmfs ${repos} /cvmfs/${repos}
done

}
