variable "ami" {
  type        = "string"
  default     = "ami-0148cde9c7d96826d"
  description = "EC2 Production AMI"
}

variable "instance_type" {
  type        = "string"
  default     = "t3.medium"
  description = "EC2 Instance Type"
}

variable "block_size" {
  default = 32
}

variable "domain" {
  type        = "string"
  description = "Domain"
}

variable "code_server_password" {
  type        = "string"
  description = "Password of Code Server"
}

