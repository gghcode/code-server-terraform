resource "aws_key_pair" "this" {
  key_name   = "${var.name_key_pair}"
  public_key = "${file("${var.path_pub_key}")}"
}

resource "aws_instance" "this" {
  ami           = "${var.ami}" # Amazon Linux AMI 2017.03.1 Seoul
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.this.key_name}"

  vpc_security_group_ids = "${data.terraform_remote_state.sg.outputs.security_group_ids}"

  root_block_device {
    volume_size = "${var.block_size}"
  }
}

resource "aws_eip_association" "this" {
  instance_id   = "${aws_instance.this.id}"
  allocation_id = "${data.terraform_remote_state.eip.outputs.eip_id}"
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = "${data.terraform_remote_state.api_gateway.outputs.rest_api_id}"
  stage_name    = "${terraform.workspace}"
  deployment_id = "${data.terraform_remote_state.api_gateway_deployment.outputs.id}"

  variables = {
    "instance_id" = "${aws_instance.this.id}"
  }
}

resource "null_resource" "preparation" {
  triggers = {
    instance = "${aws_instance.this.id}"
  }

  connection {
    host        = "${aws_eip_association.this.public_ip}"
    user        = "${var.ssh_username}"
    timeout     = "30s"
    private_key = "${file("${var.path_pri_key}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo certbot certonly --standalone -d ${var.domain} --non-interactive --agree-tos -m ${var.email} --preferred-challenges http",
      "sudo echo >> /etc/code-server/env",
      "sudo echo TLS_CERT=/etc/letsencrypt/live/${var.domain}/fullchain.pem >> /etc/code-server/env",
      "sudo echo TLS_KEY=/etc/letsencrypt/live/${var.domain}/privkey.pem >> /etc/code-server/env",
      "sudo echo PORT=${var.code_server_port} >> /etc/code-server/env",
      "sudo echo PASSWORD=${var.code_server_password} >> /etc/code-server/env",
      "sudo systemctl start code-server --no-block",
    ]
  }
}
