/**
 * Jenkins 2.0 Buildfile
 **/

 def buildBaseImage() {
   try {
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
   } finally {
     stage 'Clean-Vagrantbox'
     echo 'Properly clean the machine'
     echo 'Destroy Vagrant box'
     sh 'vagrant destroy -f'
     echo 'Properly clean the machine'
     echo 'Destroys and deletes all Vagrant boxes on build machine!'
     echo 'Required for exited builds during box downloads'
     sh './clean.sh'
   }
 }

return this;
