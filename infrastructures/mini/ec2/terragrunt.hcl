terraform {
  # extra_arguments is a block, so make sure NOT to include an equals sign
  extra_arguments "custom_vars" {
    commands  = ["apply", "plan"]
    arguments = [
      "-var", 
      "code_server_password=${get_env("CODE_SERVER_PASSWORD", "12345678")}",
      "-var",
      "domain=${get_env("CODE_SERVER_DOMAIN", "none")}"
    ]
  }
}

dependencies {
  paths = [
      "../eip", 
      "../api_gateway_deployment", 
      "../../global/lambda", 
      "../../global/security_group"
    ]
}
