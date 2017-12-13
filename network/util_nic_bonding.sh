#!/bin/bash
# bond NIC from two original nic 
# 2017-12-11 : Yuwei Chou

if [ $# -lt 5 ] ; then
    echo "usage : util_nic_bonding.sh bond_nic ip/netmask eth0_nic eth1_nic bond_mode_number"
    echo "   Eg : util_nic_bonding.sh bond0 192.168.4.202/24 eth0 eth1 4"
    exit -1
fi

BOND_INTERFACE=$1
IPNET=$2
NET_INTERFACE1=$3
NET_INTERFACE2=$4
BOND_MODE=$5

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
ip addr add $IPNET dev $BOND_INTERFACE
#ip route add default via 192.168.1.254 dev bond0
