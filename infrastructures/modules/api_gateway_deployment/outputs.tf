output "id" {
  value = "${aws_api_gateway_deployment.this.id}"
}


output "dns" {
  value = "${aws_api_gateway_deployment.this.invoke_url}"
}