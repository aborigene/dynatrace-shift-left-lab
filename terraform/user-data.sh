#!/bin/bash
# Install updates
yum update -y

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install jenkins sudo java-1.8.0-amazon-corretto-devel -y
systemctl start jenkins
systemctl enable jenkins

# downloading the cli
wget http://localhost:8080/jnlpJars/jenkins-cli.jar

# #getting default password
default_password=`cat /var/lib/jenkins/secrets/initialAdminPassword`

# #installing recommended plugins
java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:$default_password install-plugin ant antisamy-markup-formatter apache-httpcomponents-client-4-api  asm-api bootstrap5-api bouncycastle-api branch-api build-timeout caffeine-api checks-api cloudbees-folder commons-lang3-api commons-text-api credentials-binding credentials dark-theme display-url-api durable-task echarts-api eddsa-api email-ext font-awesome-api git-client git github-api github-branch-source github gradle gson-api instance-identity ionicons-api jackson2-api jakarta-activation-api jakarta-mail-api javax-activation-api jaxb jjwt-api joda-time-api jquery3-api json-api json-path-api junit ldap mailer matrix-auth matrix-project metrics mina-sshd-api-common mina-sshd-api-core okhttp-api pam-auth pipeline-build-step pipeline-github-lib pipeline-graph-analysis pipeline-graph-view pipeline-groovy-lib pipeline-input-step pipeline-milestone-step pipeline-model-api pipeline-model-definition pipeline-model-extensions pipeline-stage-step pipeline-stage-tags-metadata plain-credentials plugin-util-api resource-disposer scm-api script-security snakeyaml-api ssh-credentials ssh-slaves structs theme-manager timestamper token-macro trilead-api variant workflow-aggregator workflow-api workflow-basic-steps workflow-cps workflow-durable-task-step workflow-job workflow-multibranch workflow-scm-step workflow-step-api workflow-support ws-cleanup -restart

# # Install Docker
yum install docker -y
systemctl start docker

usermod -a -G docker ec2-user
usermod -a -G docker jenkins

# Install Node.js and Yarn
# curl -sL https://rpm.nodesource.com/setup_current.x | bash -
# yum install -y nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
yum install g++

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 22 
nvm use 22
npm install -g yarn

# Install Backstage
mkdir /opt/backstage
cd /opt/backstage
export BACKSTAGE_APP_NAME=my-backstage-app
export BACKSTAGE_DB=sqlite3
#yarn add @testing-library/react@^16.0.0 --dev
yarn list @testing-library/react
npx -yes @backstage/create-app
cd my-backstage-app
yarn install
yarn dev & 