provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "account" {
  backend = "s3"

  config {
    bucket = "yegorski-terraform-state"
    key    = "scaffolding.tfstate"
    region = "us-east-1"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.terraform_remote_state.account.vpc_id}"

  tags {
    Type = "Public"
  }
}

module "sonarqube" {
  source = "git::https://github.com/yegorski/terraform-aws-autoscaling-e2.git"

  region = "us-east-1"

  app_name = "sonarqube"
  app_port = 9000

  # EC2
  ami_owner     = "${var.aws_account_id}"
  ami_filter    = "Amazon Linux 2 SonarQube AMI*"
  instance_type = "c5.large"
  ssh_ip        = "209.122.234.196"
  ssh_key_name  = "yegorski"

  # Network
  is_internal = false
  subnet_ids  = "${data.aws_subnet_ids.public.ids}"
  vpc_id      = "${data.terraform_remote_state.account.vpc_id}"

  tags = {
    Owner       = "yegorski"
    Environment = "production"
    Source      = "https://github.com/yegorski/terraform-aws-sonarqube"
  }
}
