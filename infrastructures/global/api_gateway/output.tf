output "rest_api_id" {
  value     = "${aws_api_gateway_rest_api.this.id}"
  sensitive = true
}

output "method_resource_id" {
  value     = "${aws_api_gateway_method.this.resource_id}"
  sensitive = true
}

output "method_http_method" {
  value     = "${aws_api_gateway_method.this.http_method}"
  sensitive = true
}

output "execution_arn" {
  value     = "${aws_api_gateway_rest_api.this.execution_arn}"
  sensitive = true
}

