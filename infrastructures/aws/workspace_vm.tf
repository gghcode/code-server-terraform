resource "aws_key_pair" "my_workspace_admin" {
  key_name = "my_workspace_admin"
  public_key = "${file("${var.ec2_key_dir}/${var.ec2_key_name}.pub")}"
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
  # ingress {
  #   from_port = 80
  #   to_port = 80
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # egress {
  #   from_port = 80
  #   to_port = 80
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # Allow all inbound
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
    private_key = "${file("${var.ec2_key_dir}/${var.ec2_key_name}")}"
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/certs",
      "mkdir -p ~/scripts"
    ]
  }

  provisioner "file" {
    source = "${var.src_scripts_dir}"
    destination = "/home/${var.ec2_default_user}/scripts/"
  }

  provisioner "file" {
    source = "${var.src_service_template}"
    destination = "/home/${var.ec2_default_user}/code.service"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ec2_default_user}/scripts/*sh",
      "sudo sh ~/scripts/setup_docker.sh ${var.docker_package}",
      "sudo sh /home/${var.ec2_default_user}/scripts/bootstrap_code_server.sh ${var.vsc_password} ${var.vsc_port}"
    ]
  }
}
