output "alb_dns_name" {
  value = aws_lb.my-alb.dns_name
}

output "alb_tg_arn" {
  value = aws_lb_target_group.my-lb-tg.arn
}

output "alb_zone_id" {
  value = aws_lb.my-alb.zone_id
}