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
node('packer') {
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
  stage 'Docker-Image'
  unarchive mapping: ['blacklabelops-centos7.xz': 'blacklabelops-centos7.xz']
}