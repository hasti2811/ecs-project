variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  type = string
  default = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  type = string
  default = "10.0.4.0/24"
}

variable "az_1" {
  type = string
  default = "eu-west-2a"
}

variable "az_2" {
  type = string
  default = "eu-west-2b"
}

variable "zone_name" {
  type = string
  default = "hastiamin.co.uk"
}

variable "subdomain_name" {
  type = string
  default = "ecs-app.hastiamin.co.uk"
}