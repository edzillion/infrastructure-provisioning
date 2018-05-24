output "rocketchat-1.ip" {
  value = "${module.rocketchat-1.public_ip}"
}

output "rocketchat-2.ip" {
  value = "${module.rocketchat-2.public_ip}"
}

output "rocketchat-1.id" {
  value = "${module.rocketchat-1.instance_id}"
}

output "rocketchat-2.id" {
  value = "${module.rocketchat-2.instance_id}"
}

# output "app.1.ip" {
#   value = "${aws_instance.app.1.private_ip}"
# }

output "nat.ip" {
  value = "${aws_instance.nat.public_ip}"
}

output "elb.hostname" {
  value = "${aws_elb.app.dns_name}"
}
