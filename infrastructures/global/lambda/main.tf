terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "gghcode-server"

    workspaces {
      name = "lambda"
    }
  }
}

provider "aws" {}

resource "aws_iam_role" "this" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }  
  ]
}
EOF
}

resource "aws_iam_policy" "this" {
  policy = "${data.aws_iam_policy_document.this.json}"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${aws_iam_policy.this.arn}"
}

resource "aws_lambda_function" "this" {
  function_name    = "${var.name_schedule_lambda}"
  role             = "${aws_iam_role.this.arn}"
  filename         = "${var.name_source_code_zip}"
  handler          = "ec2_scheduler.handler"
  runtime          = "python3.7"
  source_code_hash = "${data.archive_file.sources.output_base64sha256}"
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowInvokeFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.this.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${data.terraform_remote_state.api_gateway.outputs.execution_arn}/*/*/*"
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id = "${data.terraform_remote_state.api_gateway.outputs.rest_api_id}"
  resource_id = "${data.terraform_remote_state.api_gateway.outputs.method_resource_id}"
  http_method = "${data.terraform_remote_state.api_gateway.outputs.method_http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.this.invoke_arn}"
}
