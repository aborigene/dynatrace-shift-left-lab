provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_backstage" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type = "m5.4xlarge"

  tags = {
    Name = "JenkinsBackstageInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Install updates
              yum update -y
              # Install Jenkins
              wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              yum install jenkins java-1.8.0-openjdk-devel -y
              systemctl start jenkins
              systemctl enable jenkins
              # Install Docker
              amazon-linux-extras install docker -y
              systemctl start docker
             
              usermod -a -G docker ec2-user
              usermod -a -G docker jenkins
              # Install Node.js and Yarn
              curl -sL https://rpm.nodesource.com/setup_14.x | bash -
              yum install -y nodejs
              npm install -g yarn
              # Install Backstage
              mkdir /opt/backstage
              cd /opt/backstage
              npx @backstage/create-app
              cd my-backstage-app
              yarn install
              yarn dev &
              EOF
}

output "instance_id" {
  value = aws_instance.jenkins_backstage.id
}

output "public_ip" {
  value = aws_instance.jenkins_backstage.public_ip
}