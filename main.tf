provider "aws" { 
 region = "ap-south-1" 
} 
resource "aws_instance" "web" {
  ami           = "ami-0c2af51e265bd5e0e "  # Replace with your desired AMI ID
  instance_type = "t2.micro"               # Replace with your desired instance type
  key_name      = Mumbai_New_Key           # Replace with your key pair name
  vpc_security_group_ids = ["sg-0406450f2837ba102"]   # your security group id to be replaced.
  tags = {
    Name = "Prod_Server"
    Env = "Prod"
  }
}
