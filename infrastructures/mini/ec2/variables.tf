variable "name_key_pair" {
  type        = "string"
  default     = "sub_code_server"
  description = "Name of Key Pair"
}

variable "path_pub_key" {
  type        = "string"
  default     = "~/.ssh/code_server_admin.pub"
  description = "Path of Public Key"
}

variable "path_pri_key" {
  type        = "string"
  default     = "~/.ssh/code_server_admin"
  description = "Path of Private Key"
}

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
  default     = "m.ghcode.dev"
}
