#######
# ===== TDCVS02-BWAF Service ALB =====
#######

resource "aws_lb" "STG01-TDCVS02-LB" {
  load_balancer_type = "application"
  name               = "STG-TDCVS02-BWAF"
  internal           = false
  security_groups    = ["${var.stg-allow-all-sg}"]
  subnets            = "${var.dmz_tier_subnets}"
  idle_timeout       = "60"
  enable_http2       = true
  ip_address_type    = "ipv4"

  # Merge the default tags with the name
  tags = "${merge(var.base_env_tags, map("Name", "STG-TDCVS02-BWAF"))}"
}

resource "aws_lb_listener" "STG01-TDCVS02-Listener" {
  depends_on        = ["aws_lb_target_group.STG01-TDCVS02-TG"]
  load_balancer_arn = "${aws_lb.STG01-TDCVS02-LB.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-west-2:0123456789012:certificate/8a312ecc-ce56-45f3-bb45-ceb70f38c142"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.STG01-TDCVS02-TG.arn}"
  }
}

resource "aws_lb_target_group" "STG01-TDCVS02-TG" {
  name                 = "STG-TDCVS02-BWAF"
  vpc_id               = "${var.stg_vpcid}"
  port                 = "1091"
  protocol             = "HTTPS"
  deregistration_delay = "60"
  target_type          = "instance"

  health_check {
    interval            = "30"
    path                = "/cgi-mod/index.cgi"
    port                = "8443"
    protocol            = "HTTPS"
    timeout             = "5"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    matcher             = "200"
  }

  # Merge the default tags with the name
  tags = "${merge(var.base_env_tags, map("Name", "STG-TDCVS02-BWAF"))}"

  # Don't create this until the LB is ready.
  depends_on = ["aws_lb.STG01-TDCVS02-LB"]

  # Don't destroy this listener before creating a new one.
  lifecycle {
    create_before_destroy = true
  }
}

# Looking for the WAF instance IDs

data "aws_instance" "bwaf_a" {
  filter {
    name   = "tag:Name"
    values = ["STG-BWAF01-A"]
  }
}

data "aws_instance" "bwaf_b" {
  filter {
    name   = "tag:Name"
    values = ["STG-BWAF01-B"]
  }
}

resource "aws_lb_target_group_attachment" "STG-TDCVS02-BWAFA-Att" {
  target_group_arn = "${aws_lb_target_group.STG01-TDCVS02-TG.arn}"
  target_id        = "${data.aws_instance.bwaf_a.id}"
  port             = 1091
}

resource "aws_lb_target_group_attachment" "STG-TDCVS02-BWAFB-Att" {
  target_group_arn = "${aws_lb_target_group.STG01-TDCVS02-TG.arn}"
  target_id        = "${data.aws_instance.bwaf_b.id}"
  port             = 1091
}

# We need to attach this TGs to the auto-scaling group that the BWAF CF template created

resource "aws_autoscaling_attachment" "TDCVS02_TG_AS_Attachment" {
  autoscaling_group_name = "${var.as_grp_name}"
  alb_target_group_arn   = "${aws_lb_target_group.STG01-TDCVS02-TG.arn}"
}

# Make the forward entries
resource "aws_route53_record" "STG01-TDCVS02-LB-DNSFW" {
  zone_id = "ABCDEF123456"
  name    = "tdcvs02"
  type    = "A"

  alias {
    name                   = "${aws_lb.STG01-TDCVS02-LB.dns_name}"
    zone_id                = "${aws_lb.STG01-TDCVS02-LB.zone_id}"
    evaluate_target_health = false
  }

  allow_overwrite = true

  # Don't create this until the LB is ready.
  depends_on = ["aws_lb.STG01-TDCVS02-LB"]
}

#######
# ===== UDXVS02-BWAF Service ALB =====
#######

resource "aws_lb" "STG01-UDXVS02-LB" {
  load_balancer_type = "application"
  name               = "STG-UDXVS02-BWAF"
  internal           = false
  security_groups    = ["${var.stg-allow-all-sg}"]
  subnets            = "${var.dmz_tier_subnets}"
  idle_timeout       = "60"
  enable_http2       = true
  ip_address_type    = "ipv4"

  # Merge the default tags with the name
  tags = "${merge(var.base_env_tags, map("Name", "STG-UDXVS02-BWAF"))}"
}

resource "aws_lb_listener" "STG01-UDXVS02-Listener-80" {
  depends_on        = ["aws_lb_target_group.STG01-UDXVS02-TG"]
  load_balancer_arn = "${aws_lb.STG01-UDXVS02-LB.arn}"
  port              = 80
  protocol          = "HTTP"
  #  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #  certificate_arn   = "arn:aws:acm:us-west-2:441514930411:certificate/8a312ecc-ce56-45f3-bb45-ceb70f38c142"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.STG01-UDXVS02-TG.arn}"
  }
}

resource "aws_lb_listener" "STG01-UDXVS02-Listener-443" {
  depends_on        = ["aws_lb_target_group.STG01-UDXVS02-TG"]
  load_balancer_arn = "${aws_lb.STG01-UDXVS02-LB.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-west-2:abcdef123456:certificate/8a312ecc-ce56-45f3-bb45-ceb70f38c142"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.STG01-UDXVS02-TG.arn}"
  }
}

resource "aws_lb_target_group" "STG01-UDXVS02-TG" {
  name                 = "STG-UDXVS02-BWAF"
  vpc_id               = "${var.stg_vpcid}"
  port                 = "443"
  protocol             = "HTTPS"
  deregistration_delay = "60"
  target_type          = "instance"

  health_check {
    interval            = "30"
    path                = "/cgi-mod/index.cgi"
    port                = "8443"
    protocol            = "HTTPS"
    timeout             = "5"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    matcher             = "200"
  }

  # Merge the default tags with the name
  tags = "${merge(var.base_env_tags, map("Name", "STG-UDXVS02-BWAF"))}"

  # Don't create this until the LB is ready.
  depends_on = ["aws_lb.STG01-UDXVS02-LB"]

  # Don't destroy this listener before creating a new one.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "STG-UDXVS02-BWAFA-Att" {
  target_group_arn = "${aws_lb_target_group.STG01-UDXVS02-TG.arn}"
  target_id        = "${data.aws_instance.bwaf_a.id}"
  port             = 443
}

resource "aws_lb_target_group_attachment" "STG-UDXVS02-BWAFB-Att" {
  target_group_arn = "${aws_lb_target_group.STG01-UDXVS02-TG.arn}"
  target_id        = "${data.aws_instance.bwaf_b.id}"
  port             = 443
}

# We need to attach this TGs to the auto-scaling group that the BWAF CF template created

resource "aws_autoscaling_attachment" "UDXVS02_TG_AS_Attachment" {
  autoscaling_group_name = "${var.as_grp_name}"
  alb_target_group_arn   = "${aws_lb_target_group.STG01-UDXVS02-TG.arn}"
}

# Make the forward entries
resource "aws_route53_record" "STG01-UDXVS02-LB-DNSFW" {
  zone_id = "ABCDEF123456"
  name    = "udxvs02"
  type    = "A"

  alias {
    name                   = "${aws_lb.STG01-UDXVS02-LB.dns_name}"
    zone_id                = "${aws_lb.STG01-UDXVS02-LB.zone_id}"
    evaluate_target_health = false
  }

  allow_overwrite = true

  #   # Don't create this until the LB is ready.
  depends_on = ["aws_lb.STG01-UDXVS02-LB"]
}
