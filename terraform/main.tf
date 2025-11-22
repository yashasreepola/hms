provider "aws" {
  region = "us-east-1"
}

# 1. DYNAMIC AMI LOOKUP
# Instead of hardcoding, this fetches the latest Ubuntu 22.04 image automatically.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu creator)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. SECURITY GROUP (Firewall)
# This allows your browser to reach the Java app (port 8080) and SSH (port 22).
resource "aws_security_group" "hms_sg" {
  name        = "hms_security_group"
  description = "Allow SSH and HTTP 8080"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow App access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. EC2 INSTANCE
resource "aws_instance" "hms_server" {
  ami           = data.aws_ami.ubuntu.id # Uses the dynamic ID found above
  instance_type = "t2.medium"

  # Attaches the firewall rules we created above
  vpc_security_group_ids = [aws_security_group.hms_sg.id]

  # OPTIONAL: If you have an SSH key in AWS, uncomment the line below:
  # key_name = "my-laptop-key"

  tags = {
    Name = "HMS-Server"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF
}

output "instance_public_ip" {
  description = "Use this IP to access your app: http://<IP>:8080"
  value       = aws_instance.hms_server.public_ip
}