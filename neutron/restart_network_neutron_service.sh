#!/bin/bash

service neutron-dhcp-agent restart
service neutron-l3-agent restart
service neutron-lbaasv2-agent restart
service neutron-linuxbridge-agent restart
service neutron-metadata-agent restart

service neutron-dhcp-agent status
service neutron-l3-agent status
service neutron-lbaasv2-agent status
service neutron-linuxbridge-agent status
service neutron-metadata-agent status