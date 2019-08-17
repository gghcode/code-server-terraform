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

resource "aws_key_pair" "this" {
  key_name   = "${var.name_key_pair}"
  public_key = "${file("${var.path_pub_key}")}"
}

resource "aws_instance" "this" {
  ami           = "${var.ami}" # Amazon Linux AMI 2017.03.1 Seoul
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.this.key_name}"

  vpc_security_group_ids = "${data.terraform_remote_state.sg.outputs.security_group_ids}"

  ebs_block_device {
    device_name = "${var.device_name}"
    volume_size = "${var.block_size}"
  }
}

resource "aws_eip_association" "this" {
  instance_id   = "${aws_instance.this.id}"
  allocation_id = "${data.terraform_remote_state.eip.outputs.eip_id}"
}
