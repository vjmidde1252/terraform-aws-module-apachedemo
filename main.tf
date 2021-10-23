data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


data "aws_vpc" "main" {
  id = var.vpc_id
}

data "template_file" "user_data" {
  template = file("${abspath(path.module)}/user-data.yml")
}

resource "aws_key_pair" "midde-key" {
  key_name   = "midde-key"
  public_key = var.EC2-Key
}

resource "aws_security_group" "Midde-sg" {
  name        = "Midde-sg"
  description = "SG group "
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = [var.my_ip]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.my_ip]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.midde-key.key_name
  vpc_security_group_ids = [aws_security_group.Midde-sg.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name = "${var.server_name}_Midde-ec2"
  }
}