terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "gghcode-server"

    workspaces {
      name = "sg"
    }
  }
}

provider "aws" {}

resource "aws_security_group" "ssh" {
  name        = "allow_ssh_port_from_all"
  description = "Allow SSH port from all"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "all" {
  name        = "allow_all_port_from_all"
  description = "Allow All port from all"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
