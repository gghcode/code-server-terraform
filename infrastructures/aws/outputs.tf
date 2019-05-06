output "ip" {
    value = "${aws_instance.my_workspace_ec2.*.public_ip}"
}