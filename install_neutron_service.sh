# Compute node install netwowk function

apt-get update
apt-get install -y neutron-dhcp-agent
apt-get install -y neutron-l3-agent
apt-get install -y neutron-linuxbridge-agent
apt-get install -y neutron-metadata-agent
