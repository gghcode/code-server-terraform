output "id" {
  value     = module.ec2.id
  sensitive = true
}

output "public_ip" {
  value     = module.ec2.public_ip
  sensitive = true
}

output "lambda_dns" {
  value     = module.ec2.lambda_dns
  sensitive = true
}
