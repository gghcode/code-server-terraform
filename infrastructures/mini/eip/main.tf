terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "gghcode-server"

    workspaces {
      prefix = "eip-"
    }
  }
}

provider "aws" {}

resource "aws_eip" "this" {
  vpc = true
}