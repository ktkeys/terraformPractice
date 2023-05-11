variable "aws_key_pair" {
    default = "~/aws/aws_keys/ec2.pem"
}

provider  "aws" {
    region = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    #region = var.aws_region

}



resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  vpc_id = "vpc-07705fd48475faa57"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  ami                   = "ami-0889a44b331db0194"
  key_name               = "ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  subnet_id              = "subnet-0b266309a8e75e1da"




connection {
    type = "ssh"
    host = self .public_ip
    user = "ec2-user"
    private_key = file(var.aws_key_pair)
}

provisioner "remote-exec" {
    inline = [
        // install httpd 
        "sudo yum install httpd -y",

        // start server 
        "sudo service httpd start",

        //copy a file
        "echo Adam Miller is a buttmunch '¯\\''_(ツ)_/¯' - XO Kati | sudo tee /var/www/html/index.html" 
    ]
}
}