variable "alb_sg_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "cert_arn" {
  type = string
}