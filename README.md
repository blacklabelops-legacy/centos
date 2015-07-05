[![Docker Hub Info](http://dockeri.co/image/blacklabelops/centos)](https://registry.hub.docker.com/u/blacklabelops/centos)

[![Docker Build Status](http://hubstatus.container42.com/blacklabelops/centos)](https://registry.hub.docker.com/u/blacklabelops/centos)
[![Circle CI](https://circleci.com/gh/blacklabelops/centos/tree/master.svg?style=svg)](https://circleci.com/gh/blacklabelops/centos/tree/master)

In my view the most flexible way to build Docker Base Images. This project builds docker base images from kickstart files.

I have wrapped this [CentOS Tutorial](https://github.com/CentOS/sig-cloud-instance-build/tree/master/docker) inside a working Vagrant box to build my own centos base images. It uses [KatzJ Ami-Creator](https://github.com/katzj/ami-creator) to build images and extracts them with [Guestfish](http://libguestfs.org/guestfish.1.html) inside Docker compatible tar balls.

Builds the Docker Image [blacklabelops/centos](https://atlas.hashicorp.com/blacklabelops/boxes/dockerdev) Image on Dockerhub.

## Features

* Ready-to-Use Vagrant box with working software.
* Full control over the build with AMI kickstart files.
   * Free choice of distribution
	* Control over Repositories
	* Control over Packages, Timezone and Locals
	* CentOS: Remove and Disable SystemD

## Usage

Spin up the box and log in!

~~~~
$ vagrant up
$ vagrant ssh
~~~~    

Change into the mounted project folder.

~~~~
$ cd /vagrant
~~~~

Build the Image!

~~~~
$ ./buildBaseImage.sh blacklabelops-centos7.ks blacklabelops-centos7
~~~~   

Extract the image in a tarball.

~~~~
$ ./extractImage.sh blacklabelops-centos7.img blacklabelops-centos7
~~~~ 

Now its time to exit the box!

~~~~
$ exit
~~~~ 

Importing the tarball into docker:

~~~~
$ cat blacklabelops-centos7.tar.gz | docker import - blacklabelops/centos
~~~~ 

## References

* [Blacklabelops Docker CenOS Image](https://registry.hub.docker.com/u/blacklabelops/centos/)
* [KatzJ Ami-Creator](https://github.com/katzj/ami-creator)
* [Guestfish](http://libguestfs.org/guestfish.1.html)
* [Vagrant Homepage](https://www.vagrantup.com/)
* [Virtualbox Homepage](https://www.virtualbox.org/)
* [Docker Homepage](https://www.docker.com/)
