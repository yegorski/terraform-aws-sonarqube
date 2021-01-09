variable "app_name" {
  type        = "string"
  description = "Name used in naming all resources in the module."
}

variable "aws_account_id" {
  type        = "string"
  description = "AWS account ID."
}

variable "ssh_ip" {
  type        = "string"
  description = "Specify IP address to allow SSH access to the EC2 instace (such as your IP). Defaults to no IP (aka no SSH access)."
  default     = ""
}
