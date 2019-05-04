resource "aws_key_pair" "my_workspace_admin" {
  key_name = "my_workspace_admin"
  public_key = "${file("~/.ssh/my_workspace_admin.pub")}"
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
    protocol = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_instance" "my_workspace_ec2" {
  ami = "ami-e21cc38c" # Amazon Linux AMI 2017.03.1 Seoul
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.my_workspace_admin.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.http.id}",
    "${data.aws_security_group.default.id}"
  ]

  provisioner "file" {
    source = "provision-remote-vsc.sh"
    destination = "/scripts/provision-remote-vsc.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /scripts/provision-remote-vsc.sh",
      "sh /scripts/provision-remote-vsc.sh",
    ]
  }
}
