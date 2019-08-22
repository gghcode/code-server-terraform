data "terraform_remote_state" "api_gateway" {
  backend = "remote"
  config = {
    organization = "gghcode-server"

    workspaces = {
      name = "api-gateway"
    }
  }
}