output "lb_dns_name" {
  value = "${module.autoscaling_ec2.lb_dns_name}"
}

output "lb_zone_id" {
  value = "${module.autoscaling_ec2.lb_zone_id}"
}
