#!/bin/bash

#create snaphost for each VM

virsh list --all
# virsh snapshot-list $VMNAME | sed '1,2'd | awk '{print $1}'
ALLVMS=($(virsh list --all | grep 'shut off' |awk '{print $2}'))

for (( i=0; i<=((${#ALLVMS[@]}-1)); i++ ));
do
    echo virsh start ${ALLVMS[i]};
    virsh start ${ALLVMS[i]};
done
virsh list --all
