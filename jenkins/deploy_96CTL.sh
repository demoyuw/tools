whoami
pwd
# rsync -avP localadmin@10.50.0.32:~/tarball.tgz .
rsync -avP ../PackTarball/tarball/tarball.tgz .
sudo rm -rf /home/yuwei/openstack_sas/NFS/*

# revert all host
sudo virsh snapshot-revert 96CTL1 1523503583
sudo virsh snapshot-revert 96COM1 1523503960
sudo virsh snapshot-revert 96COM2 1523504040
sudo virsh snapshot-revert 96COM3 1523504064

# start all host
sudo virsh start 96CTL1
sudo virsh start 96COM1
sudo virsh start 96COM2
sudo virsh start 96COM3

sleep 30

#Install optional COM1
rsync -avP tarball.tgz localadmin@10.50.0.97:~/
ssh localadmin@10.50.0.97 tar xfz /home/localadmin/tarball.tgz
rsync -avP 96CTL/allone_deploy.conf localadmin@10.50.0.97:~/conf/
ssh -f localadmin@10.50.0.97 "sudo /home/localadmin/bin/isc21_optional_ppa.sh"


#Install optional COM2
rsync -avP tarball.tgz localadmin@10.50.0.98:~/
ssh localadmin@10.50.0.98 tar xfz /home/localadmin/tarball.tgz
rsync -avP 96CTL/allone_deploy.conf localadmin@10.50.0.98:~/conf/
ssh -f localadmin@10.50.0.98 "sudo /home/localadmin/bin/isc21_optional_ppa.sh"

#Install optional COM3
rsync -avP tarball.tgz localadmin@10.50.0.99:~/
ssh localadmin@10.50.0.99 tar xfz /home/localadmin/tarball.tgz
rsync -avP 96CTL/allone_deploy.conf localadmin@10.50.0.99:~/conf/
ssh -f localadmin@10.50.0.99 "sudo /home/localadmin/bin/isc21_optional_ppa.sh"


#deploy CTL1
rsync -avP tarball.tgz localadmin@10.50.0.96:~/
ssh localadmin@10.50.0.96 tar xfz /home/localadmin/tarball.tgz
rsync -avP 96CTL/allone_deploy.conf localadmin@10.50.0.96:~/conf/
ssh localadmin@10.50.0.96 /home/localadmin/bin/util_sysid.sh ens3
rsync -avP 96CTL/license.* localadmin@10.50.0.96:~/action/
ssh localadmin@10.50.0.96 "sudo /home/localadmin/bin/util_date.sh now"
ssh localadmin@10.50.0.96 "sudo /home/localadmin/bin/isc21_install.sh 96CTL1"


#Deploy COM1
ssh localadmin@10.50.0.97 "wget http://10.50.0.96:8088/home/localadmin/conf/allone_deploy.conf"
ssh localadmin@10.50.0.97 "cp -pr ~/allone_deploy.conf ~/conf/"
ssh -f localadmin@10.50.0.97 "sudo /home/localadmin/bin/isc21_compute_install.sh 96COM1 10.50.0.97 ens4:192.168.0.97 ens5:192.168.1.97 ens6:192.168.2.97"

#Deploy COM2
ssh localadmin@10.50.0.98 "wget http://10.50.0.96:8088/home/localadmin/conf/allone_deploy.conf"
ssh localadmin@10.50.0.98 "cp -pr ~/allone_deploy.conf ~/conf/"
ssh -f localadmin@10.50.0.98 "sudo /home/localadmin/bin/isc21_compute_install.sh 96COM2 10.50.0.98 ens4:192.168.0.98 ens5:192.168.1.98 ens6:192.168.2.98"

#Deploy COM3
ssh localadmin@10.50.0.99 "wget http://10.50.0.96:8088/home/localadmin/conf/allone_deploy.conf"
ssh localadmin@10.50.0.99 "cp -pr ~/allone_deploy.conf ~/conf/"
ssh -f localadmin@10.50.0.99 "sudo /home/localadmin/bin/isc21_compute_install.sh 96COM3 10.50.0.99 ens4:192.168.0.99 ens5:192.168.1.99 ens6:192.168.2.99"

