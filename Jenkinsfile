/** Jenkins 2.0 Buildfile
 *
 * Master Jenkins 2.0 can be started by typing:
 * docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
 *
 * Slave 'packer' can be started by typing:
 * docker run -d -v /dev/vboxdrv:/dev/vboxdrv --link jenkins:jenkins -e "SWARM_CLIENT_LABELS=docker" blacklabelops/hashicorp-virtualbox
 *
 * Slave 'docker' can be started by typing:
 * docker run -d -v /var/run/docker.sock:/var/run/docker.sock --link jenkins:jenkins -e "SWARM_CLIENT_LABELS=docker" blacklabelops/swarm-dockerhost
 **/

/**
 * Build parameters, must be adjusted when forked!
 **/
def env.dockerTagName = 'blacklabelops/centos'

node('vagrant') {
  checkout scm

  // Properly clean the machine
  stage 'Clean'
  sh './build/clean.sh'
  /**
   * Destroys and deletes all Vagrant boxes on build machine!
   * Required for exited builds during box downloads.
   **/
  sh './clean.sh'
  sh 'vagrant up'

  // Build and extract the base image
  stage 'Build'
  sh 'rm -f blacklabelops-centos7.xz'
  sh './build.sh'
  sh './dockerbox/squashImage.sh'

  stage 'Save-Docker-Tar'
  archive 'blacklabelops-centos7.xz'

  // Properly clean the machine
  stage 'Clean-Vagrantbox'
  sh 'vagrant destroy -f'
  /**
   * Destroys and deletes all Vagrant boxes on build machine!
   * Required for exited builds during box downloads.
   **/
  sh './clean.sh'
}

node('dockerhub') {
  checkout scm

  // Build the docker base image
  stage 'Docker-Image'
  unarchive mapping: ['blacklabelops-centos7.xz': 'blacklabelops-centos7.xz']
  sh 'docker build --no-cache -t ${dockerTagName} .'
}
