module "rocketchat-1" {
  source          = "modules/base"
  name            = "${var.name_prefix}-rocketchat-1"
  name_prefix     = "${var.name_prefix}"
  security_groups = "${list(aws_security_group.default.id, aws_security_group.allow_ssh.id)}"
  key_name        = "${aws_key_pair.deployer.key_name}"

  # secrets_key = "circles-sealer-1"
  instance_profile_name = "${aws_iam_instance_profile.rocketchat.name}"
  vpc_id                = "${aws_vpc.default.id}"
  subnet_id             = "${aws_subnet.public.id}"
}

module "rocketchat-2" {
  source          = "modules/base"
  name            = "${var.name_prefix}-rocketchat-2"
  name_prefix     = "${var.name_prefix}"
  security_groups = "${list(aws_security_group.default.id, aws_security_group.allow_ssh.id)}"
  key_name        = "${aws_key_pair.deployer.key_name}"

  # secrets_key = "circles-sealer-1"
  instance_profile_name = "${aws_iam_instance_profile.rocketchat.name}"
  vpc_id                = "${aws_vpc.default.id}"
  subnet_id             = "${aws_subnet.public.id}"
}

/* App servers */
# resource "aws_instance" "app" {
#   count             = 2
#   ami               = "${lookup(var.amis, var.region)}"
#   instance_type     = "t2.micro"
#   subnet_id         = "${aws_subnet.private.id}"
#   security_groups   = ["${aws_security_group.default.id}"]
#   key_name          = "${aws_key_pair.deployer.key_name}"
#   source_dest_check = false
#   user_data         = "${file("cloud-config/app.yml")}"

#   //instance profile
#   tags = {
#     Name = "${var.name_prefix}-app-${count.index}"
#   }
# }

/* Load balancer */
resource "aws_elb" "app" {
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

  instances = ["${module.rocketchat-1.instance_id}", "${module.rocketchat-2.instance_id}"]

  tags = {
    Name = "${var.name_prefix}-elb"
  }
}
