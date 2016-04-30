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
 env.DockerImageName = 'blacklabelops/centos'
 def dockerTags = ["7", "7.2", "7.2.1511"] as String[]
node('vagrant') {
  checkout scm

  stage 'Pre-Clean-Vagrantbox'
  echo 'Properly clean the machine'
  echo 'Destroy Vagrant box'
  sh 'vagrant destroy -f'
  echo 'Properly clean the machine'
  echo 'Destroys and deletes all Vagrant boxes on build machine!'
  echo 'Required for exited builds during box downloads'
  sh './clean.sh'

  stage 'Build-Base'
  echo 'Starting Vagrant box'
  sh 'vagrant up'
  echo 'Removing old build artifact'
  sh 'rm -f blacklabelops-centos7.xz'
  echo 'Building base image'
  sh './build.sh'
  echo 'Updating and sqashing base image'
  sh './dockerbox/squashImage.sh'

  stage 'Archive-Image'
  echo 'Archiving base image'
  archive 'blacklabelops-centos7.xz'

  stage 'Post-Clean-Vagrantbox'
  echo 'Properly clean the machine'
  echo 'Destroy Vagrant box'
  sh 'vagrant destroy -f'
  echo 'Properly clean the machine'
  echo 'Destroys and deletes all Vagrant boxes on build machine!'
  echo 'Required for exited builds during box downloads'
  sh './clean.sh'

}
node('docker') {
  checkout scm

  stage 'Docker-Image'
  echo 'Building the docker base image'
  unarchive mapping: ['blacklabelops-centos7.xz': 'blacklabelops-centos7.xz']
  sh 'docker build --no-cache -t $DockerImageName .'

  stage 'Dockerhub-Login'
  dockerHubLogin()

  stage 'Dockerhub-Push'
  dockerPush('$DockerImageName','latest')

  stage 'Dockerhub-Push-Tags'
  for (int i=0;i < dockerTags.length;i++) {
      dockerPush('$DockerImageName',dockerTags[i])
  }

  stage 'Dockerhub-Logout'
  sh 'docker logout'
}

/**
 * Docker needs three parameters to work, I distributed those Credentials inside
 * two Jenkins-UsernamePassword Credentials.
 * Credentials 'Dockerhub' with Dockerhub username and password
 * Credentials 'DockerhubEmail' with the email inside the password field.
 **/
def dockerHubLogin() {
  echo 'Login to Dockerhub with Credentials Dockerhub and DockerhubEmail'
  withCredentials([[$class: 'UsernamePasswordMultiBinding',
    credentialsId: 'Dockerhub',
    usernameVariable: 'USERNAME',
    passwordVariable: 'PASSWORD']]) {
    withCredentials([[$class: 'UsernamePasswordMultiBinding',
      credentialsId: 'DockerhubEmail',
      usernameVariable: 'DUMMY',
      passwordVariable: 'EMAIL']]) {
      sh 'docker login --email $EMAIL --username $USERNAME --password $PASSWORD'
    }
  }
}

def dockerPush(imageName, tagName) {
    sh 'docker push ' + imageName + ':' + tagName
}
