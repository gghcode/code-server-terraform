variable "instance_type" {
  type    = "string"
  default = "t2.medium"
}

variable "ami" {
  type    = "string"
  default = "ami-067c32f3d5b9ace91"
}

variable "ec2_default_user" {
  default = "ubuntu"
}

variable "pem_key_path" {
  default = "~/.ssh"
}

variable "pem_key_name" {
  default = "my_workspace_admin"
}

variable "src_path_scripts" {
  default = "../../scripts/"
}

variable "src_path_service" {
  default = "../../system/code.service"
}
