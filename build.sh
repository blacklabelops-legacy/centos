#!/bin/bash -x

set -o errexit    # abort script at first error
vagrant ssh -c "cd /vagrant && ./buildBaseImage.sh blacklabelops-centos7.ks blacklabelops-centos7"
test -f blacklabelops-centos7.img
vagrant ssh -c "cd /vagrant && ./extractImage.sh blacklabelops-centos7.img blacklabelops-centos7"
test -f blacklabelops-centos7.xz
