variable "path_ec2_scheduler_py" {
  type        = "string"
  default     = "../../../src/ec2_scheduler.py"
  description = "Path of python script that schedules ec2"
}

variable "name_source_code_zip" {
  type        = "string"
  default     = "ec2_scheduler.zip"
  description = "Name of source code zip"
}

variable "name_schedule_lambda" {
  type        = "string"
  default     = "code_server_schedule"
  description = "Resource name of schedule lambda"
}
