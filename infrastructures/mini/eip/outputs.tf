output "eip_id" {
  value     = "${aws_eip.this.id}"
  sensitive = true
}

output "eip_ip" {
  value     = "${aws_eip.this.public_ip}"
  sensitive = true
}
