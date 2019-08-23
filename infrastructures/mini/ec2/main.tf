terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "gghcode-server"

    workspaces {
      prefix = "ec2-"
    }
  }
}

provider "aws" {}

module "ec2" {
  source = "../../modules/ec2"

  name_key_pair = "${var.name_key_pair}"
  path_pub_key  = "${var.path_pub_key}"
  path_pri_key  = "${var.path_pri_key}"

  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  block_size    = "${var.block_size}"

  domain               = "${var.domain}"
  code_server_password = "${var.code_server_password}"
}
