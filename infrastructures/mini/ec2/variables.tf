variable "ami" {
  type        = "string"
  default     = "ami-0123532c705a9bd92"
  description = "EC2 Minimal AMI"
}

variable "instance_type" {
  type        = "string"
  default     = "t3.small"
  description = "EC2 Instance Type"
}

variable "block_size" {
  default = 8
}

variable "domain" {
  type        = "string"
  description = "Domain"
}

variable "code_server_password" {
  type        = "string"
  description = "Password of Code Server"
}

