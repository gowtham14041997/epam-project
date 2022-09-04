variable "region" {
  type          = string
  default       = "us-east-1"
  description   = "AWS VPC region"
}

variable "subnet_cidrs" {
  type          = list(string)
  default       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
  description   = "CIDRs used for public, webserver, appserver and db subnets"
}
