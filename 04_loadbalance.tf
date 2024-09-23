resource "aws_lb" "main_nlb" {
  name               = "public-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [ aws_security_group.nlb.id ]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name     = "main_nlb"
    Resource = var.resource_tag
  }
}

resource "aws_lb_target_group" "appserver_tg" {
  name     = "appserver-target-group"
  port     = var.appserver_port
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    protocol           = "TCP"
    port               = "traffic-port"
  }
}


resource "aws_lb_listener" "app_nlb_listener" {
  load_balancer_arn = aws_lb.main_nlb.arn
  port              = var.appserver_port
  protocol          = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.appserver_tg.arn
  }
}

resource "aws_autoscaling_attachment" "appserver_lb" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  lb_target_group_arn    = aws_lb_target_group.appserver_tg.arn

  depends_on = [
    aws_autoscaling_group.app_asg,
    aws_lb_target_group.appserver_tg
  ]
}
