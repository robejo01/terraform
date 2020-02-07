# AWS01 Victoria Station Target Group
# Weights will need to be set manually

resource "aws_lb_target_group" "vss-tg" {
  name                 = "StageS01-VSS"
  port                 = 13010
  protocol             = "HTTP"
  vpc_id               = "${var.stg_vpc}"
  deregistration_delay = 60
  slow_start           = 0
  tags                 = "${local.appzone_tags}"

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 30
    matcher             = 200
  }

}

#AWS01 Victoria Station TG Attachment

resource "aws_lb_target_group_attachment" "vss-tg-attach" {
  count            = 3
  target_group_arn = "${aws_lb_target_group.vss-tg.arn}"
  target_id        = "${element(var.az_instances, count.index)}"
  port             = 13010
}
