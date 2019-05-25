resource "aws_key_pair" "this" {
  key_name   = "my_workspace_admin"
  public_key = "${file("${var.pem_key_path}/${var.pem_key_name}.pub")}"
}

resource "aws_security_group" "ssh" {
  name        = "allow_ssh_from_all"
  description = "Allow SSH port from all"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http" {
  name        = "allow_http_from_all"
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

resource "aws_instance" "my_workspace_ec2" {
  ami           = "${var.ami}"                    # Amazon Linux AMI 2017.03.1 Seoul
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.this.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.http.id}",
  ]

  connection {
    user        = "${var.ssh_username}"
    type        = "ssh"
    private_key = "${file("${var.pem_key_path}/${var.pem_key_name}")}"
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/scripts",
      "mkdir -p ~/system",
    ]
  }

  provisioner "file" {
    source      = "${var.src_scripts_dir_path}"
    destination = "/home/${var.ssh_username}/scripts/"
  }

  provisioner "file" {
    source      = "${var.src_services_dir_path}"
    destination = "/home/${var.ssh_username}/system/code.service"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.ssh_username}/scripts/*sh",
      "sudo ~/scripts/setup_machine.sh",
      "VSC_PASSWORD=${var.vsc_password} VSC_PORT=${var.vsc_port} sudo -E ~/scripts/bootstrap_code_server.sh",
    ]
  }
}

resource "aws_eip" "this" {
  instance = "${aws_instance.my_workspace_ec2.id}"
  vpc      = true
}
