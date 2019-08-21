output "id" {
  value = module.ec2.id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "lambda_dns" {
  value = module.ec2.lambda_dns
}
