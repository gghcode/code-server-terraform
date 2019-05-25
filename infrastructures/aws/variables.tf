variable "pem_key_path" {
  default = "~/.ssh"
}

variable "pem_key_name" {
  default = "my_workspace_admin"
}

variable "instance_type" {
  type    = "string"
  default = "t2.medium"
}

variable "ami" {
  type    = "string"
  default = "ami-067c32f3d5b9ace91"
}

variable "ssh_username" {
  default = "ubuntu"
}

variable "src_scripts_dir_path" {
  default = "../../scripts/"
}

variable "src_services_dir_path" {
  default = "../../system/code.service"
}

# VSC Variables
variable "vsc_password" {
  default = ""
}

variable "vsc_port" {
  default = "80"
}