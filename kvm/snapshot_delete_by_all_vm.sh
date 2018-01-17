VM_LIST=($(virsh list --all |head -n -1 | sed '1,2'd | awk '{print $2}'))

for (( j=0; j<=((${#VM_LIST[@]}-1)); j++ ));
do
    virsh snapshot-list ${VM_LIST[j]} 
    # virsh snapshot-list $VMNAME | sed '1,2'd | awk '{print $1}'
    SNAPSHOT_LISTS=($(virsh snapshot-list ${VM_LIST[j]} | sed '1,2'd | awk '{print $1}'))

    for (( i=((${#SNAPSHOT_LISTS[@]}-1)); i>=0; i-- ));
    do
        echo "virsh snapshot-delete ${VM_LIST[j]} ${SNAPSHOT_LISTS[i]}";
        virsh snapshot-delete ${VM_LIST[j]} ${SNAPSHOT_LISTS[i]};
    done
done
