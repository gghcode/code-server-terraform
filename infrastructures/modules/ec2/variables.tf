variable "name_key_pair" {
  type        = "string"
  description = "Name of Key Pair"
}

variable "path_pub_key" {
  type        = "string"
  description = "Path of Public Key"
}

variable "path_pri_key" {
  type        = "string"
  description = "Path of Private Key"
}

variable "ami" {
  type        = "string"
  default     = "ami-0123532c705a9bd92"
  description = "EC2 Minimal AMI"
}

variable "instance_type" {
  type        = "string"
  default     = "t3.micro"
  description = "EC2 Instance Type"
}

variable "block_size" {
  description = "EC2 Volume Size"
}

variable "ssh_username" {
  type        = "string"
  default     = "ubuntu"
  description = "EC2 SSH Username"
}

variable "email" {
  type        = "string"
  default     = "gyuhwan.a.kim@gmail.com"
  description = "Email for certbot"
}

variable "domain" {
  type        = "string"
  description = "Domain for certbot"
}

variable "code_server_port" {
  default     = 443
  description = "Port of Code Server"
}

variable "code_server_password" {
  type        = "string"
  description = "Password of Code Server"
}

