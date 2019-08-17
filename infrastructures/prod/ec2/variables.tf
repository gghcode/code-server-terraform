variable "name_key_pair" {
  type        = "string"
  default     = "code_server_admin"
  description = "Name of Key Pair"
}

variable "path_pub_key" {
  type        = "string"
  default     = "~/.ssh/code_server_admin.pub"
  description = "Path of Public Key"
}

variable "ami" {
  type        = "string"
  default     = "ami-0f4fe291a0647e5e5"
  description = "EC2 AMI"
}

variable "instance_type" {
  type        = "string"
  default     = "t3.micro"
  description = "EC2 Instance Type"
}

variable "block_size" {
  default = 32
}

variable "ssh_username" {
  type        = "string"
  default     = "ubuntu"
  description = "EC2 SSH Username"
}

variable "device_name" {
  type        = "string"
  default     = "/dev/sdh"
  description = "EC2 Device Name"
}


