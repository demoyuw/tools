#!/bin/bash
# bond NIC from two original nic 
# 2017-12-11 : Yuwei Chou

if [ $# -lt 4 ] ; then
    echo "usage : util_nic_bonding.sh bond_nic eth0_nic eth1_nic bond_mode_number"
    echo "   Eg : util_nic_bonding.sh bond0 eth0 eth1 4"
    exit -1
fi

BOND_INTERFACE=$1
NET_INTERFACE1=$2
NET_INTERFACE2=$3
BOND_MODE=$4

ping -c1 -W1 8.8.8.8 &> /dev/null
if [ "$?" == "0" ]; then
    search=$(dpkg -l | grep ifenslave)
    if [ "$search" == "" ];then
        apg-get update
        apt-get install ifenslave -y
    fi
fi

search=$(cat /proc/modules| grep bonding)
if [ "$search" == "" ];then
    modprobe bonding mode=$BOND_MODE miimon=100 max_bonds=4
fi

ip link set $NET_INTERFACE1 down
ip link set $NET_INTERFACE2 down
ifenslave $BOND_INTERFACE $NET_INTERFACE1 $NET_INTERFACE2
ip link set $BOND_INTERFACE up
#ip addr add 192.168.1.1/24 dev bond0
#ip route add default via 192.168.1.254 dev bond0