# ALB
resource "aws_security_group" "sg-alb" {
  name        = "alb-sg"
  description = "security group for ALB, allow traffic from internet for http/https and container port"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "alb-ingress-http" {
  security_group_id = aws_security_group.sg-alb.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb-ingress-https" {
  security_group_id = aws_security_group.sg-alb.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "alb-ingress-container_port" {
  security_group_id = aws_security_group.sg-alb.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
}

resource "aws_vpc_security_group_egress_rule" "alb-egress" {
  security_group_id = aws_security_group.sg-alb.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}

# ECS
resource "aws_security_group" "sg-ecs" {
  name        = "ecs-sg"
  description = "security group for ECS, allow traffic coming from ALB for http/https and container port"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs-ingress-http" {
  security_group_id = aws_security_group.sg-ecs.id
  referenced_security_group_id = aws_security_group.sg-alb.id
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "ecs-ingress-https" {
  security_group_id = aws_security_group.sg-ecs.id
  referenced_security_group_id = aws_security_group.sg-alb.id
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "ecs-ingress-container_port" {
  security_group_id = aws_security_group.sg-ecs.id
  referenced_security_group_id = aws_security_group.sg-alb.id
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
}

resource "aws_vpc_security_group_egress_rule" "ecs-egress" {
  security_group_id = aws_security_group.sg-ecs.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}