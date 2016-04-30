#!/bin/bash -x

set -o errexit    # abort script at first error

#Change directory
cd dockerbox

#Copy the binary
cp ../blacklabelops-centos7.xz .
test -f ./blacklabelops-centos7.xz

#Start vagrant box
vagrant up

#Build the image with the update routine
vagrant ssh -c "docker build --file /vagrant/Dockerfile --tag centosupdate /vagrant"

#Run container
vagrant ssh -c "docker run --name centossquash centosupdate bash"

#Squash the containers content
vagrant ssh -c "docker cp centossquash:/ - | xz --best >> /vagrant/dockerbox/blacklabelops-centos7-updated.xz"

#Destroy box
vagrant destroy -f

#Go back
cd ..

#Move file
test -f dockerbox/blacklabelops-centos7-updated.xz
mv -f dockerbox/blacklabelops-centos7-updated.xz blacklabelops-centos7.xz
rm -f dockerbox/blacklabelops-centos7.xz
