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

bond_interface=$1
IP=$2
Netmask=$3
GW=$4
net_interface1=$5
net_interface2=$6
bond_mode=$7

ping -c1 -W1 8.8.8.8 &> /dev/null
if [ "$?" == "0" ]; then
    search=$(dpkg -l | grep ifenslave)
    if [ "$search" == "" ];then
        apt-get update
        apt-get install ifenslave -y
    fi
fi

result=$(cat /etc/modules | grep 'bonding mode=`bond_mode` miimon=100')
echo $result

if [ "$result" == "" ];then
    sed -e '/rtc/abonding mode=`bond_mode` miimon=100 max_bonds=4' -i /etc/modules
fi

modprobe bonding mode=$bond_mode miimon=100 max_bonds=4

result=$(cat /etc/network/interfaces | grep ${bond_interface})
if [ "$result" == "" ];then
    /etc/network/interfaces
    sed auto ${net_interface1}
    iface ${net_interface1} inet manual
    bond-master ${bond_interface}
    
    auto ${net_interface2}
    iface ${net_interface2} inet manual
    bond-master ${bond_interface}
    
    auto ${bond_interface} 
    iface ${bond_interface} inet static
    address $IP
    netmask $Netmask
    gateway $GW
    post-up ifenslave ${bond_interface} ${net_interface1} ${net_interface2}
    post-down ifenslave -d bonding ${net_interface1} ${net_interface2}
fi
reboot