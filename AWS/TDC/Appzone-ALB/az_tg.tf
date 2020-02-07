# AWS01 Appzone Target Group
# Weights will need to be set manually

resource "aws_lb_target_group" "az-tg" {
  name                 = "StageS01-Appzone"
  port                 = 10080
  protocol             = "HTTP"
  vpc_id               = "${var.stg_vpc}"
  deregistration_delay = 60
  slow_start           = 0
  tags                 = "${local.appzone_tags}"

  health_check {
    path                = "/ws/bs/system/status"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 30
    matcher             = 200
  }

}

# AWS01 Appzone TG Attachment

# resource "aws_lb_target_group_attachment" "az-tg-attach" {
#   count            = 3
#   target_group_arn = "${aws_lb_target_group.az-tg.arn}"
#   target_id        = "${element(var.az_instances, count.index)}"
#   port             = 10080
# }
