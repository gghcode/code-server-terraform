data "terraform_remote_state" "sg" {
  backend = "remote"
  config = {
    organization = "gghcode-server"

    workspaces = {
      name = "sg"
    }
  }
}

data "terraform_remote_state" "eip" {
  backend = "remote"
  config = {
    organization = "gghcode-server"

    workspaces = {
      name = "eip-mini"
    }
  }
}
