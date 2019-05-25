output "ip" {
  value = "${aws_eip.this.public_ip}"
}

output "dns" {
  value = "${aws_eip.this.public_dns}"
}

# output "instance_id" {
#   value = "${aws_instance.my_workspace_ec2.*.id}"
# }
