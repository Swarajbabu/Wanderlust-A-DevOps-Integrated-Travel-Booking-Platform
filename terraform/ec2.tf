# 1. Fetch latest Ubuntu 22.04 LTS AMI dynamically
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical official Ubuntu owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Automatically generate SSH Key Pair for EC2 access
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "${var.app_name}-jenkins-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save the private key to a local file for SSH access
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/jenkins_key.pem"
  file_permission = "0400"
}

# 3. Jenkins & Docker EC2 Instance (Free Tier Eligible t2.micro)
resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro" # 100% Free Tier Eligible on your account
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.jenkins_key.key_name
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  # User Data: Setup 4GB Swap Memory + Install Jenkins, Java 17, Docker & AWS CLI
  user_data = <<-EOF
              #!/bin/bash
              set -e

              # 1. Allocate 4GB Swap Space for smooth Free Tier execution
              fallocate -l 4G /swapfile
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile none swap sw 0 0' >> /etc/fstab

              # 2. Update system packages
              apt-get update -y
              apt-get upgrade -y

              # 3. Install Java 21 (Required by latest Jenkins releases)
              apt-get install -y openjdk-21-jdk git curl wget apt-transport-https ca-certificates gnupg lsb-release

              # 4. Add official Jenkins repository key & install Jenkins
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /etc/apt/trusted.gpg.d/jenkins.asc > /dev/null
              echo "deb https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

              apt-get update -y
              apt-get install -y jenkins

              # 5. Install Docker Engine
              apt-get install -y docker.io
              systemctl enable docker
              systemctl start docker

              # 6. Grant Jenkins and Ubuntu users permission to run Docker
              usermod -aG docker jenkins
              usermod -aG docker ubuntu

              # 7. Install AWS CLI v2 on EC2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              apt-get install -y unzip
              unzip -q awscliv2.zip
              ./aws/install

              # 8. Start and enable Jenkins
              systemctl enable jenkins
              systemctl restart jenkins
              EOF

  tags = {
    Name = "${var.app_name}-jenkins-server"
  }
}
