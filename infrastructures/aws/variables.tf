variable "ec2_instance_type" {
  type    = "string"
  default = "t2.medium"
}

variable "ec2_ami" {
  type    = "string"
  default = "ami-067c32f3d5b9ace91"
}

variable "ec2_default_user" {
  default = "ubuntu"
}

variable "ec2_key_dir" {
  default = "~/.ssh"
}

variable "ec2_key_name" {
  default = "my_workspace_admin"
}

variable "src_path_scripts" {
  default = "../../scripts/"
}

variable "src_path_service" {
  default = "../../system/code.service"
}
