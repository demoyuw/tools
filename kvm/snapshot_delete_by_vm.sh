VMNAME=$1
virsh snapshot-list $VMNAME 
# virsh snapshot-list $VMNAME | sed '1,2'd | awk '{print $1}'
SNAPSHOT_LISTS=($(virsh snapshot-list $VMNAME | sed '1,2'd | awk '{print $1}'))

for (( i=((${#SNAPSHOT_LISTS[@]}-1)); i>=0; i-- ));
do
    echo snapshot-delete $VMNAME ${SNAPSHOT_LISTS[i]};
    virsh snapshot-delete $VMNAME ${SNAPSHOT_LISTS[i]};
done
