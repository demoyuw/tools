#!/bin/bash
sudo chown -R jenkins.jenkins packFolder/*
rsync -avP ../GetWarFiles/sql packFolder/
rsync -avP ../GetWarFiles/frontend packFolder/
rsync -avP backend_api packFolder/backend/openstack_mitaka/
rsync -avP backendScheduler packFolder/backend/openstack_mitaka/
rsync -avP --exclude=deploy/backend --exclude=deploy/sql --exclude=deploy/frontend deploy/* packFolder/
rsync -avP monitor packFolder/
rsync -avP openstack/nova/nova-stable-mitaka/* packFolder/backend/openstack_mitaka/
rsync -avP openstack/neutron_lbaas packFolder/backend/openstack_mitaka/
rsync -avP openstack/cinder/cinder-stable-mitaka/cinder packFolder/backend/openstack_mitaka/
rsync -avP tools packFolder/backend/openstack_mitaka/
rsync -avP VM_Backup packFolder/backend/openstack_mitaka/
cd packFolder
rm -f tarball.tgz.jenkins
sudo chown -R localadmin.localadmin *
sudo chmod -R 755 *
./tar.sh
mv tarball.tgz tarball.tgz.jenkins
cp -pr tarball.tgz.jenkins ../tarball/
rm -f tarball.tgz.jenkins
