resource "aws_lb" "PoCgenpactalb" {
  name               = "PoCgenpactalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.albsg
  subnets            = var.albsubnet
  enable_deletion_protection = false
  tags = {
    Environment = "POC"
  }
}
resource "aws_lb_target_group" "albTG" { 
  name     = "PoC-albTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.albvpc
}
resource "aws_lb_target_group_attachment" "tgattachment" {
  target_group_arn = aws_lb_target_group.albTG.arn
  target_id        = var.alb-tg-target_id
  port             = 80
}
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.PoCgenpactalb.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albTG.arn 
  }
}