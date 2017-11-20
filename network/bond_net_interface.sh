#!/bin/bash

#bond two network interface

if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

net_interface1=$1
net_interface2=$2
bond_interface=$3
bond_mode=$4

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
    sed -e '/rtc/abonding mode=`bond_mode` miimon=100' -i /etc/modules
fi

modprobe bonding mode=6 miimon=100

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
    post-up ifenslave ${bond_interface} ${net_interface1} ${net_interface2}
    post-down ifenslave -d bonding ${net_interface1} ${net_interface2}
    
fi 