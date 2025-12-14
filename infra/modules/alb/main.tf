resource "aws_lb" "my-alb" {
  name               = "alb-for-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "my-lb-tg" {
  name        = "my-lb-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
  path                = "/"
  protocol            = "HTTP"
  interval            = 30
  healthy_threshold   = 3
  unhealthy_threshold = 3
  matcher             = "200"
}
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10" # USING MODERN CIPHER POLICY
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-lb-tg.arn
  }
}