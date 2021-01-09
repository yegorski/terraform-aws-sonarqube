module "autoscaling_ec2" {
  source = "git::https://github.com/yegorski/terraform-aws-autoscaling-e2.git"

  region = "${var.region}"

  # Application
  app_name = "sonarqube"
  app_port = 9000

  # EC2
  ami_owner     = "${var.ami_owner}"
  ami_filter    = "${var.ami_filter}"
  instance_type = "${var.instance_type}"
  ssh_ip        = "${var.ssh_ip}"
  ssh_key_name  = "${var.ssh_key_name}"

  # Network
  is_internal = "${var.is_internal}"
  subnet_ids  = "${var.subnet_ids}"
  vpc_id      = "${var.vpc_id}"

  tags = "${var.tags}"
}
