variable "ec2_instance_type" {
    type = "string"
    default = "t2.micro"
}

variable "ec2_ami" {
    type = "string"
    default = "ami-078e96948945fc2c9"
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

variable "src_scripts_dir" {
    default = "../../scripts"
}

variable "src_bootstrap_sh" {
    default = "../../scripts/provision-remote-vsc.sh"
}

variable "docker_package" {
    default = "18.06.1~ce~3-0~ubuntu"
}