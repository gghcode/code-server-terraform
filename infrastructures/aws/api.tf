resource "aws_api_gateway_rest_api" "this" {
    name = "CodeScheduleAPI"
}

resource "aws_api_gateway_resource" "this" {
    rest_api_id = "${aws_api_gateway_rest_api.this.id}"
    parent_id = "${aws_api_gateway_rest_api.this.root_resource_id}"
    path_part = "vscode"
}

resource "aws_api_gateway_method" "this" {
    rest_api_id = "${aws_api_gateway_rest_api.this.id}"
    resource_id = "${aws_api_gateway_resource.this.id}"
    http_method = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
    rest_api_id = "${aws_api_gateway_rest_api.this.id}"
    resource_id = "${aws_api_gateway_method.this.resource_id}"
    http_method = "${aws_api_gateway_method.this.http_method}"

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = "${aws_lambda_function.this.invoke_arn}"
}

resource "aws_api_gateway_deployment" "this" {
    depends_on = [
        "aws_api_gateway_integration.this"
    ]

    rest_api_id = "${aws_api_gateway_rest_api.this.id}"
    stage_name = "prod"
}

resource "aws_lambda_permission" "this" {
    statement_id = "AllowInvokeFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.this.arn}"
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"
}





