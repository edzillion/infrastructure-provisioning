output "instance_id" {
  value = "${aws_instance.this.id}"
}

output "instance_ip" {
  value = "${aws_instance.this.private_ip}"
}