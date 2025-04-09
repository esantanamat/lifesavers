# Fetch latest Ubuntu 20.04 AMI from AWS SSM Parameter Store
data "aws_ssm_parameter" "ubuntu_20_04" {
  name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# Provision an EC2 instance
resource "aws_instance" "my_ec2_instance" {
  ami           = data.aws_ssm_parameter.ubuntu_20_04.value
  instance_type = var.instance_type
  key_name      = aws_key_pair.my_key.key_name

  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "FlaskAppInstance"
  }
}

# Security group to allow SSH, HTTP, and Flask port access
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH, HTTP, and app traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]  # Limit to your IP
  }

  ingress {
    description = "Flask App"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Import your SSH public key into AWS
resource "aws_key_pair" "my_key" {
  key_name   = "my-ec2-key"
  public_key = file("~/.ssh/my-aws-key.pub")
}
