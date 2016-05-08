/**
 * Jenkins 2.0 Buildfile
 **/

/**
 * Build parameters, must be adjusted when forked!
 *
 **/
dockerImageName = 'blacklabelops/centos'
dockerTags = ["7", "7.2", "7.2.1511"] as String[]
dockerTestCommands =
  ["echo hello world",
   "ps -All",
   "uname -r",
   "whoami",
   "cat /etc/hosts",
   "cat /etc/passwd",
   "yum check-update" ] as String[]
dockerRepositories = [["","Dockerhub","DockerhubEmail"]] as String[][]

def getBranchName() {
  def branchName = env.JOB_NAME.replaceFirst('.+/', '')
  echo 'Building on Branch: ' + branchName
  def tagPostfix = ''
  if (branchName != null && !'master'.equals(branchName)) {
     tagPostfix = branchName
  }
  return tagPostfix
}

return this;
