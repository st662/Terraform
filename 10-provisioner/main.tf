provider "aws" {
  region = "us-east-1"
}

# Creating key-pair
resource "aws_key_pair" "key-tf" {
  key_name   = "key-tf"
  public_key = file("~/.ssh/id_rsa.pub")
}

# creating security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  dynamic "ingress" {
    for_each = [22, 80, 8080, 443, 9090, 9000]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Creating Ec2 instance
resource "aws_instance" "web" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key-tf.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source      = "entry-script.sh"
    destination = "/home/ubuntu/entry-script.sh"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > output.txt"
  }

  # provisioner "local-exec" {
  #   working_dir = "/c/Users/pc/Desktop"
  #   command     = "echo ${self.public_ip} > myip.txt"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "ifconfig > /tmp/ifconfig.output",
  #     "echo 'hello gaurav'> /tmp/test.txt"
  #   ]
  # }
  provisioner "remote-exec" {
    script = file("entry-script.sh")
  }

  tags = {
    Name = "first-tf-instance"
  }
}