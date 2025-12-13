variable "alb_tg_arn" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "img_uri" {
  type = string
}