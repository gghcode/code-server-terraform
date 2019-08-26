terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "gghcode-server"

    workspaces {
      prefix = "api-gateway-deployment-"
    }
  }
}

provider "aws" {}

module "api_gateway_deployment" {
  source = "../../modules/api_gateway_deployment"
}