#!/bin/bash

service neutron-dhcp-agent start
service neutron-l3-agent start
service neutron-lbaasv2-agent start
service neutron-linuxbridge-agent start
service neutron-metadata-agent start
service neutron-server start

service neutron-dhcp-agent status
service neutron-l3-agent status
service neutron-lbaasv2-agent status
service neutron-linuxbridge-agent status
service neutron-metadata-agent status
service neutron-server status