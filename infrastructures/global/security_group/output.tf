output "security_group_ids" {
  value = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.all.id}"
  ]
  sensitive = true
}
