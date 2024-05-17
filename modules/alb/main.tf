# ----------------- AWS Load Balancer ------------------- #

# data "aws_acm_certificate" "cert" {
#   domain      = "devops.kbnhvn-project.eu"
#   statuses    = ["ISSUED"]
#   most_recent = true
# }

resource "aws_lb" "k3s_lb" {
  name               = "k3s-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "k3s-alb"
  }
}

resource "aws_lb_target_group" "k3s_lb_tg" {
  name        = "k3s-targets"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 30
    path                = "/healthz"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "k3s-targets"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.k3s_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s_lb_tg.arn
  }
}

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.k3s_lb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   # certificate_arn   = data.aws_acm_certificate.cert.arn
#   certificate_arn = "arn:aws:acm:eu-west-3:564088821524:certificate/d761ec40-2352-42cc-8cee-288e0ad8f96a"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.k3s_lb_tg.arn
#   }
# }

# resource "aws_lb_listener_certificate" "ssl_certificate" {
#   listener_arn    = aws_lb_listener.https.arn
#   certificate_arn = data.aws_acm_certificate.cert.arn
# }

resource "aws_lb_target_group_attachment" "k3s_lb_master_tg_attachment" {
	target_group_arn = aws_lb_target_group.k3s_lb_tg.arn
	target_id = var.master_node
	port = 80
}

resource "aws_autoscaling_attachment" "k3s_lb_workers_tg_attachment" {
  autoscaling_group_name = var.workers_asg
  lb_target_group_arn   = aws_lb_target_group.k3s_lb_tg.arn
}