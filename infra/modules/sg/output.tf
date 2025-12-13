output "alb_sg_id" {
  value = aws_security_group.sg-alb.id
}

output "ecs_sg_id" {
  value = aws_security_group.sg-ecs.id
}