# AWS01 Appzone External Facing ALB
# We will attempt to be importing this stuff as it's already been deployed.

resource "aws_lb" "az_alb" {
  name                       = "StageS01-App-ALB"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = ["${var.sg_id}"]
  subnets                    = "${var.subnets}"
  enable_deletion_protection = false
  tags                       = "${local.appzone_tags}"
}

# AWS01 Load Balancer Listener
# We will attempt to be importing this stuff as it's already been deployed.

resource "aws_lb_listener" "az_listener" {
  load_balancer_arn = "${aws_lb.az_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.cert_arn}"

  default_action {
    type = "forward"
    # Since this Target Group already exists since before we started deploying with terraform, we'll need to import this following TG since we didn't build it here.
    target_group_arn = "aws_lb_target_group.StageS01-App-Int.arn"
  }
}
