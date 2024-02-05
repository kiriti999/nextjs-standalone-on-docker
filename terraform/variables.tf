variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region"
}

variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}

variable "ami" {
  type    = string
  default = "ami-0770726357cfe8240"
}

variable "prod_image_version" {
  description = "Application docker image name with version"
  type        = string
  default     = "skillpact:latest"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_name" {
  description = "Name of instance"
  type        = string
  default     = "nextjs-standalone-webserver"
}

variable "private_key" {
  description = "File path of private key."
  type        = string
  default     = "skillpact"
}

variable "key_pair_name" {
  type        = string
  description = "Name of keypair in AWS"
  default     = "skillpact"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "image_tag" {
  type    = string
  default = "dev-v1"
}

variable "env_name" {
  type = string
}

variable "dev_image_version" {
  type = string
}

variable "port" {
  type = string
}

variable "acm_ssl_arn" {
  type    = string
  default = "arn:aws:acm:ap-south-1:238369675568:certificate/df0ee229-f1bb-4c69-b989-c62e5e9f90ee"
}

variable "load_balancer_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:ap-south-1:238369675568:listener/app/skillpact-load-balancer/adda4076807d972b/edaa6064cab982f8"
}

variable "skillpact_security_group" {
  type    = string
  default = "sg-0d28c3dfbcf767f65"
}
