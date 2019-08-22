terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "gghcode-server"

    workspaces {
      name = "api-gateway"
    }
  }
}

provider "aws" {}

resource "aws_api_gateway_rest_api" "this" {
  name = "${var.name_api_gateway}"
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = "${aws_api_gateway_rest_api.this.id}"
  parent_id   = "${aws_api_gateway_rest_api.this.root_resource_id}"
  path_part   = "vscode"
}

resource "aws_api_gateway_method" "this" {
  rest_api_id   = "${aws_api_gateway_rest_api.this.id}"
  resource_id   = "${aws_api_gateway_resource.this.id}"
  http_method   = "POST"
  authorization = "NONE"
}
