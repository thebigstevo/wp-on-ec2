resource "aws_vpc" "wp-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "wp-vpc"
    }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "wp-subnet" {
  vpc_id = aws_vpc.wp-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_internet_gateway" "wp-igw" {
  vpc_id = aws_vpc.wp-vpc.id
  tags = {
    Name = "wp-igw"
  }
}

resource "aws_route_table" "wp-rt" {
  vpc_id = aws_vpc.wp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp-igw.id
  }
  tags = {
    Name = "wp-rt"
  }
}

resource "aws_route_table_association" "wp-rta" {
  subnet_id = aws_subnet.wp-subnet.id
  route_table_id = aws_route_table.wp-rt.id
}

resource "aws_security_group" "wordpress_sg" {
  name = "wordpress_sg"
  vpc_id = aws_vpc.wp-vpc.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "wordpress_sg"
  }
}
resource "aws_instance" "wordpress_ec2" {
  ami           = "ami-0e9085e60087ce171" # Ubuntu 24.04 AMI for eu-west-1
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.wp-subnet.id
  security_groups        = [aws_security_group.wordpress_sg.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name


  user_data = <<-EOF
    #!/bin/bash
    touch /var/log/user_data.log
    exec > /var/log/user_data.log 2>&1
    set -ex

    echo "Starting system update..."
    apt update -y
    echo "System update complete."

    echo "Installing SSM agent..."
    apt install -y amazon-ssm-agent
    systemctl start amazon-ssm-agent
    systemctl enable amazon-ssm-agent

    echo "Installing Apache, PHP, and MySQL client..."
    apt update -y
    apt install apache2 php mysql-client php-mysql unzip wget -y
    systemctl start apache2
    systemctl enable apache2

    echo "Downloading and setting up WordPress..."
    cd /var/www/html
    wget https://wordpress.org/latest.zip
    unzip latest.zip
    mv wordpress/* .
    rm -rf wordpress latest.zip
    chown -R www-data:www-data /var/www/html/
    chmod -R 755 /var/www/html
    systemctl restart apache2

    echo "Setup complete."


        EOF
        }

        output "ec2_public_ip" {
        value = aws_instance.wordpress_ec2.public_ip
        }

        resource "aws_iam_role" "ssm_role" {
        name = "ssm_role"
        assume_role_policy = <<EOF
        {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
            }
        ]
        
        }
        EOF
}

resource "aws_iam_policy_attachment" "ssm_iam_policy_attach" {
  name = "attach_ssm_policy"
  roles = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}