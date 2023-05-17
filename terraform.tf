# Define VPC resources
resource "aws_vpc" "mobilicis_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "mobilicis" {
  vpc_id     = aws_vpc.mobilicis_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Define security group with port 80 open
resource "aws_security_group" "mobilicis_security_group" {
  name        = "mobilicis-security-group"
  description = "Allow traffic on port 80"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 instances
resource "aws_instance" "instance1" {
  ami           = "ami-xxxxxxxx"  # Replace with the Ubuntu 20.04 LTS AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mobilicis.id
  vpc_security_group_ids = [aws_security_group.mobilicis_security_group.id]
}

resource "aws_instance" "instance2" {
  ami           = "ami-xxxxxxxx"  # Replace with the Ubuntu 20.04 LTS AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mobilicis.id
  vpc_security_group_ids = [aws_security_group.mobilicis_security_group.id]
}

# Create a load balancer
resource "aws_lb" "mobilicis_load_balancer" {
  name               = "mobilicis-load-balancer"
  load_balancer_type = "application"
  subnets            = [aws_subnet.mobilicis.id]
}

# Attach instances to the load balancer
resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb.mobilicis_load_balancer.arn
  target_id        = aws_instance.instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb.mobilicis_load_balancer.arn
  target_id        = aws_instance.instance2.id
  port             = 80
}
