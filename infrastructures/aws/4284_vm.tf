resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = "${file("~/.ssh/web_admin.pub")}"
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

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_instance" "web" {
  ami = "ami-e21cc38c" # Amazon Linux AMI 2017.03.1 Seoul
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.web_admin.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
    "${data.aws_security_group.default.id}"
  ]
}