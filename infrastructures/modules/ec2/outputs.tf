output "id" {
  value = "${aws_instance.this.id}"
}


output "ip" {
  value = "${aws_instance.this.public_ip}"
}

output "public_ip" {
  value = "${data.terraform_remote_state.eip.outputs.eip_ip}"
}
