#!/bin/bash

#clear all load balance on this user


if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
username='yuwei'

source ~/creds/${username}-openrc.sh

pool_ids=($(neutron lbaas-pool-list |head -n -1 | sed '1,3'd | awk '{print $2}'))

for (( i=0; i<=((${#pool_ids[@]}-1)); i++ ));
do
    echo ${pool_ids[i]} ;
    pool_ids_members=($(neutron lbaas-member-list ${pool_ids[i]} |head -n -1 | sed '1,3'd | awk '{print $2}'))
    for (( j=0; j<=((${#pool_ids_members[@]}-1)); j++ ));
    do
        neutron lbaas-member-delete ${pool_ids_members[j]} ${pool_ids[i]}
    done 
    neutron lbaas-pool-delete ${pool_ids[i]}
done

listener_ids=($(neutron lbaas-listener-list |head -n -1 | sed '1,3'd | awk '{print $2}'))
for (( i=0; i<=((${#listener_ids[@]}-1)); i++ ));
do
    neutron lbaas-listener-delete ${listener_ids[i]}
done

loadbalancer_ids=($(neutron lbaas-loadbalancer-list |head -n -1 | sed '1,3'd | awk '{print $2}'))
for (( i=0; i<=((${#loadbalancer_ids[@]}-1)); i++ ));
do
    neutron lbaas-loadbalancer-delete ${loadbalancer_ids[i]}
done