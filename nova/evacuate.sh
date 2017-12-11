source /home/localadmin/creds/yuwei-openrc.sh
DEST_HOST="COM2"

vm_list=($(nova list |head -n -1 | sed '1,3'd | awk '{print $2}'))


for (( i=0; i<=((${#vm_list[@]}-1)); i++ ));
# for (( i=0; i<=1; i++ ));
do
    echo ${vm_list[i]} ;
    nova evacuate ${vm_list[i]} ${DEST_HOST}
done
