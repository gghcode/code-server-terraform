output "id" {
  value     = module.api_gateway_deployment.id
  sensitive = true
}

output "dns" {
  value     = module.api_gateway_deployment.dns
  sensitive = true
}
