resource "aws_key_pair" "my_workspace_admin" {
  key_name = "my_workspace_admin"
  public_key = "${file("${var.ec2_pubkey_path}")}"
}

resource "aws_security_group" "ssh" {
  name = "allow_ssh_from_all"
  description = "Allow SSH port from all"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http" {
  name = "allow_http_from_all"
  description = "Allow http port from all"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_instance" "my_workspace_ec2" {
  ami = "${var.ec2_ami}" # Amazon Linux AMI 2017.03.1 Seoul
  instance_type = "${var.ec2_instance_type}"
  key_name = "${aws_key_pair.my_workspace_admin.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.http.id}",
    "${data.aws_security_group.default.id}"
  ]

  connection {
    user        = "${var.ec2_default_user}"
    type        = "ssh"
    private_key = "${file("${var.ec2_prikey_path}")}"
    timeout     = "2m"
  }

  provisioner "file" {
    source = "${var.src_bootstrap_sh}"
    destination = "/home/${var.ec2_default_user}/provision-remote-vsc.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ec2_default_user}/provision-remote-vsc.sh",
      "sudo sh /home/${var.ec2_default_user}/provision-remote-vsc.sh",
    ]
  }
}
