variable "ec2_instance_type" {
    type = "string"
    default = "t2.micro"
}

variable "ec2_ami" {
    type = "string"
    default = "ami-0225ede930e1db1d9"
}

variable "ec2_default_user" {
    default = "ubuntu"
}

variable "ec2_key_name" {
    default = "my_workspace_admin"
}

variable "ec2_prikey_path" {
    default = "~/.ssh/${var.ec2_key_name}"
}


variable "ec2_pubkey_path" {
    default = "~/.ssh/${var.ec2_key_name}.pub"
}

variable "src_bootstrap_sh" {
    default = "../../scripts/provision-remote-vsc.sh"
}