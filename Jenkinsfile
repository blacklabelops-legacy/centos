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
 * Build parameters, must be adjusted when branched or forked!
 **/
def repository = 'https://github.com/blacklabelops/centos.git'
def branch = 'master'
def dockerTagName = 'blacklabelops/centos'
node('packer') {
  //git branch: branch, changelog: false, poll: false, url: repository
  checkout scm

  stage 'Clean'
  sh './build/clean.sh'
  sh './clean.sh'
  sh 'vagrant up'

  stage 'Build'
  sh 'rm -f blacklabelops-centos7.xz'
  sh './build.sh'
  sh './dockerbox/squashImage.sh'

  stage 'Save-Docker-Tar'
  archive 'blacklabelops-centos7.xz'

  stage 'Clean-Vagrantbox'
  sh 'vagrant destroy -f'
  sh './clean.sh'
}
node('docker') {
  //git branch: branch, changelog: false, poll: false, url: repository
  checkout scm

  stage 'Docker-Image'
  unarchive mapping: ['blacklabelops-centos7.xz': 'blacklabelops-centos7.xz']
  sh 'docker build --no-cache -t ${dockerTagName} .'
}
