output "rest_api_id" {
  value = "${aws_api_gateway_rest_api.this.id}"
}

output "method_resource_id" {
  value = "${aws_api_gateway_method.this.resource_id}"
}

output "method_http_method" {
  value = "${aws_api_gateway_method.this.http_method}"
}

output "execution_arn" {
  value = "${aws_api_gateway_rest_api.this.execution_arn}"
}

