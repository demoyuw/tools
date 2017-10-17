#!/bin/bash

#user create loadbalance and test

if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

source ~/creds/ayuwei-openrc.sh

private_subnet_id=$(neutron subnet-list | grep '172.16.0.0/24' | awk '{print $2}' )
public_subnet_id=$(neutron subnet-list | grep '10.10' | awk '{print $2}' )
echo $private_subnet_id
echo $public_subnet_id

port_ids[0]=$(neutron lbaas-loadbalancer-create --name l4_pri_lber $private_subnet_id | grep 'vip_port_id' | awk '{print $4}' )
port_ids[1]=$(neutron lbaas-loadbalancer-create --name l4_pub_lber $public_subnet_id | grep 'vip_port_id' | awk '{print $4}' )
port_ids[2]=$(neutron lbaas-loadbalancer-create --name l7_pri_lber $private_subnet_id | grep 'vip_port_id' | awk '{print $4}' )
port_ids[3]=$(neutron lbaas-loadbalancer-create --name l7_pub_lber $public_subnet_id | grep 'vip_port_id' | awk '{print $4}' )

neutron lbaas-listener-create --name l4_pri_ler --loadbalancer l4_pri_lber --protocol TCP --protocol-port 80
neutron lbaas-listener-create --name l4_pub_ler --loadbalancer l4_pub_lber --protocol TCP --protocol-port 80
neutron lbaas-listener-create --name l7_pri_ler --loadbalancer l7_pri_lber --protocol HTTP --protocol-port 80
neutron lbaas-listener-create --name l7_pub_ler --loadbalancer l7_pub_lber --protocol HTTP --protocol-port 80

neutron lbaas-pool-create --name l4_pri_pool --listener l4_pri_ler --lb-algorithm ROUND_ROBIN --protocol TCP
neutron lbaas-pool-create --name l4_pub_pool --listener l4_pub_ler --lb-algorithm ROUND_ROBIN --protocol TCP
neutron lbaas-pool-create --name l7_pri_pool --listener l7_pri_ler --lb-algorithm ROUND_ROBIN --protocol HTTP
neutron lbaas-pool-create --name l7_pub_pool --listener l7_pub_ler --lb-algorithm ROUND_ROBIN --protocol HTTP

neutron lbaas-member-create --subnet $private_subnet_id --address 172.16.0.10 --protocol-port 80 l4_pri_pool
neutron lbaas-member-create --subnet $private_subnet_id --address 172.16.0.11 --protocol-port 80 l4_pri_pool

neutron lbaas-member-create --subnet $public_subnet_id --address 10.10.21.134 --protocol-port 80 l4_pub_pool
neutron lbaas-member-create --subnet $public_subnet_id --address 10.10.21.139 --protocol-port 80 l4_pub_pool

neutron lbaas-member-create --subnet $private_subnet_id --address 172.16.0.10 --protocol-port 80 l7_pri_pool
neutron lbaas-member-create --subnet $private_subnet_id --address 172.16.0.11 --protocol-port 80 l7_pri_pool

neutron lbaas-member-create --subnet $public_subnet_id --address 10.10.21.134 --protocol-port 80 l7_pub_pool
neutron lbaas-member-create --subnet $public_subnet_id --address 10.10.21.139 --protocol-port 80 l7_pub_pool

source ~/creds/admin-openrc.sh
for (( i=0; i<=3; i++ ))
do
    neutron port-update --no-security-groups  --port_security_enabled=false ${port_ids[$i]}
done

source ~/creds/ayuwei-openrc.sh
echo neutron lbaas-loadbalancer-list

