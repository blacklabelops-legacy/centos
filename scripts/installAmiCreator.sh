#!/bin/bash

sudo yum install -y epel-release
sudo yum install -y python-imgcreate compat-db43 libguestfs-tools

curl -sSLO https://github.com/katzj/ami-creator/archive/ami-creator-0.2.tar.gz
tar xfz ami-creator-0.2.tar.gz
rm -f ami-creator-0.2.tar.gz
chown -R vagrant:vagrant ami-creator-ami-creator-0.2/
sudo cp ami-creator-ami-creator-0.2/ami-creator.py /opt/
