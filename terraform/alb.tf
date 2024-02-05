data "aws_lb" "existing_alb" {
  name = "skillpact-load-balancer"
}

data "aws_lb_target_group" "existing_nextjs_tg" {
  name = "nextjs-app-tg"
}

data "aws_lb_listener" "existing_listener" {
  arn = var.load_balancer_arn
}

resource "aws_lb_listener_rule" "nextjs_app_routing_preflight" {
  listener_arn = data.aws_lb_listener.existing_listener.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.existing_nextjs_tg.arn
  }

  condition {
    http_header {
      http_header_name  = "Origin"
      values            = ["skillpact.in", "*://www.skillpact.in"]
    }
  }
}

resource "aws_lb_listener_rule" "nextjs_app_routing" {
  listener_arn = data.aws_lb_listener.existing_listener.arn

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.existing_nextjs_tg.arn
  }

  condition {
    http_header {
      http_header_name  = "X-Service-Identifier"
      values            = ["skillpact.in"]
    }
  }
}

resource "aws_lb_target_group_attachment" "nextjs_target" {
  target_group_arn = data.aws_lb_target_group.existing_nextjs_tg.arn
  target_id        = module.ec2_instance.id
  port             = 4444
}
