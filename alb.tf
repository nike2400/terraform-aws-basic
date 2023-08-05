# ---------------------------------
#  Application Load Balancer
# ---------------------------------

resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.web_sg.id
  ]
  subnets = [
    aws_subnet.public_subnet-1a.id,
    aws_subnet.public_subnet-1c.id,
  ]
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.project}-${var.environment}-app-alb-tg"
  port     = 3000 # Node.js
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-alb-tg"
    Project = var.project
    Env     = var.environment
  }

}

# associate Instance with elb target group
resource "aws_lb_target_group_attachment" "alb_instance" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.app_server.id # EC2 instance id  
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80 # port allowed
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443 # port allowed
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.alb_cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
