#!/bin/bash

#ubuntu14.04 install apache2 

if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
IP_name=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
echo $IP_name

ping -c1 -W1 8.8.8.8 &> /dev/null
if [ "$?" == "0" ]; then
    apt-get update
    apt-get install apache2 -y
    sed -e "s/Apache2 Ubuntu Default Page/"$IP_name"/g" -i /var/www/html/index.html 
fi

