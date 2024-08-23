# Configure the AWS provider
provider "aws" {
  region = "ap-south-1"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main_VPC"
  }
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Public_Subnet"
  }
}

# Create a private subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Private_Subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Main_IGW"
  }
}

# Create a public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public_Route_Table"
  }
}

# Create a route in the public route table
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create a private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Private_Route_Table"
  }
}

# Associate the private route table with the private subnet
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Create a security group for the EC2 instances
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web_SG"
  }
}

data "aws_key_pair" "existing" {
  key_name = "Terraform_Keypair"
}

# Create an EC2 key pair
resource "aws_key_pair" "main_key" {
count = data.aws_key_pair.existing.id == "" ? 1 : 0
key_name   = "Terraform_Keypair"  
public_key = file("~/public_keypair.pub")  # Replace with the path to your public key file
  
}

# Launch an EC2 instance in the public subnet
resource "aws_instance" "public_web" {
  count         = 1
  ami           = "ami-0c2af51e265bd5e0e"  # Replace with your desired AMI ID
  instance_type = "t2.micro"               # Replace with your desired instance type
  key_name      = aws_key_pair.main_key.key_name  # Use the created key pair

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Prod_Server"
    Env  = "Prod"
  }
}
