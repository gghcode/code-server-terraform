data "terraform_remote_state" "sg" {
  backend = "remote"
  config = {
    organization = "gghcode-server"

    workspaces = {
      name = "sg"
    }
  }
}

data "terraform_remote_state" "api_gateway" {
  backend = "remote"
  config = {
    organization = "gghcode-server"

    workspaces = {
      name = "api-gateway"
    }
  }
}

data "terraform_remote_state" "eip" {
  backend = "remote"
  config = {
    organization = "gghcode-server"

    workspaces = {
      name = "eip-${terraform.workspace}"
    }
  }
}

data "terraform_remote_state" "api_gateway_deployment" {
  backend = "remote"
  config = {
    organization = "gghcode-server"

    workspaces = {
      name = "api-gateway-deployment-${terraform.workspace}"
    }
  }
}
