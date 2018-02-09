#!/bin/bash

#create snaphost for each VM

virsh list --all
# virsh snapshot-list $VMNAME | sed '1,2'd | awk '{print $1}'
ALLVMS=($(virsh list --all | sed '1,2'd | sed '$d' |awk '{print $2}'))

for (( i=0; i<=((${#ALLVMS[@]}-1)); i++ ));
do
    echo snapshot-create ${ALLVMS[i]};
    virsh snapshot-create ${ALLVMS[i]};
done