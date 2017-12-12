#!/bin/bash

#bond two network interface

if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ $# -lt 6 ] ; then
    echo "usage : util_nic_bonding.sh bond_nic IP Netmask GW eth0_nic eth1_nic bond_mode_number"
    echo "   Eg : util_nic_bonding.sh bond0 192.168.0.100 255.255.255.0 192.168.0.254 eth0 eth1 4"
    exit -1
fi

BOND_INTERFACE=$1
IP=$2
NETMASK=$3
GW=$4
NET_INTERFACE1=$5
NET_INTERFACE2=$6
BOND_MODE=$7

ping -c1 -W1 8.8.8.8 &> /dev/null
if [ "$?" == "0" ]; then
    search=$(dpkg -l | grep ifenslave)
    if [ "$search" == "" ];then
        apt-get update
        apt-get install ifenslave -y
    fi
fi

result=$(cat /etc/modules | grep 'bonding')
echo $result

if [ "$result" == "" ];then
    sed '$abonding mode='$BOND_MODE' miimon=100 max_bonds=4' -i /etc/modules
fi

echo modprobe bonding mode=$BOND_MODE miimon=100 max_bonds=4

modprobe bonding mode=$BOND_MODE miimon=100 max_bonds=4


result=$(cat /etc/network/interfaces | grep ${BOND_INTERFACE})
if [ "$result" == "" ];then
    echo auto $NET_INTERFACE1 >> /etc/network/interfaces
    echo iface $NET_INTERFACE1 inet manual >> /etc/network/interfaces
    echo bond-master ${BOND_INTERFACE} >> /etc/network/interfaces
    echo auto $NET_INTERFACE2 >> /etc/network/interfaces
    echo iface $NET_INTERFACE2 inet manual >> /etc/network/interfaces
    echo bond-master $BOND_INTERFACE >> /etc/network/interfaces
    echo auto $BOND_INTERFACE >> /etc/network/interfaces
    echo iface $BOND_INTERFACE inet static >> /etc/network/interfaces
    echo address $IP >> /etc/network/interfaces
    echo netmask $NETMASK >> /etc/network/interfaces
    echo gateway $GW >> /etc/network/interfaces
    echo post-up ifenslave $BOND_INTERFACE $NET_INTERFACE1 $NET_INTERFACE2 >> /etc/network/interfaces
    echo post-down ifenslave -d bonding $NET_INTERFACE1 $NET_INTERFACE2 >> /etc/network/interfaces
fi
cat /etc/network/interfaces
reboot

