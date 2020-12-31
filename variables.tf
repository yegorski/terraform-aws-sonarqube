variable "region" {
  type        = "string"
  description = "The AWS region. Defaults to `us-east-1`."
  default     = "us-east-1"
}

variable "tags" {
  type        = "map"
  description = "A map of tags to apply to all AWS resources."
}

################################################################################
### EC2                                                                      ###
################################################################################
variable "ami_filter" {
  type        = "string"
  description = "Filter to obtain the Amazon Marketplace Image to use for the server. Defaults to `amzn2-ami-hvm-*-x86_64-gp2`."
  default     = "amzn2-ami-hvm-*-x86_64-gp2"
}

variable "ami_owner" {
  type        = "string"
  description = "Owner of the AMI to use for the server. Used to look for the AMI on the marketplace. Defaults to `amazon`."
  default     = "amazon"
}

variable "associate_public_ip_address" {
  type        = "string"
  description = "Boolean to control whether to create a public IP address for the server. Defaults to `false`."
  default     = false
}

variable "instance_type" {
  type        = "string"
  description = "EC2 instance size. Defaults to `c5.large`."
  default     = "c5.large"
}

variable "ssh_ip" {
  type        = "string"
  description = "Specify IP address to allow SSH access to the EC2 instace (such as your IP). Defaults to no IP (aka no SSH access)."
  default     = ""
}

variable "ssh_key_name" {
  type        = "string"
  description = "The name of the SSH key to use for the launched instances."
}

variable "volume_size" {
  type        = "string"
  description = "The size of the EBS volume for the server. Defaults to `50` (GB)."
  default     = "50"
}

################################################################################
### Network                                                                  ###
################################################################################
variable "alb_certificate_arn" {
  type        = "string"
  description = "The ARN of the ALB certificate to attach to the load balancer. Defaults to none (aka no SSL)."
  default     = ""
}

variable "is_internal" {
  type        = "string"
  description = "Boolean to control whether the load balancer is interal. Defaults to `true`."
  default     = true
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDs for server and load balancer."
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC ID to launch resources in."
}
