/* App servers */
resource "aws_instance" "app" {
  count             = 2
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "t2.micro"
  subnet_id         = "${aws_subnet.private.id}"
  security_groups   = ["${aws_security_group.default.id}"]
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  user_data         = "${file("cloud-config/app.yml")}"

  tags = {
    Name = "${var.name_prefix}-app-${count.index}"
  }
}

/* Load balancer */
resource "aws_elb" "app" {
  name            = "${aws_subnet.private.id}-elb"
  subnets         = ["${aws_subnet.public.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 3000
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 3000
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  instances = ["${aws_instance.app.*.id}"]

  tags = {
    Name = "${aws_subnet.private.id}-elb"
  }
}
