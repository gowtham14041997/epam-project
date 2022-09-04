#--------------------------------------------------------------------------------
#Internet gateway
#----------------

variable "vpc_id" {
  type          = string
  description   = "VPC ID"
}

variable "igw_name" {
  type          = string
  default       = "My internet gateway"
  description   = "Internet gateway name"
}

#--------------------------------------------------------------------------------
#NAT gateway
#-----------

variable "public_subnet_id" {
  type          = string
  description   = "Public subnet ID for NAT gatway"
}

variable "natgw_name" {
  type          = string
  default       = "My NAT gateway"
  description   = "NAT gateway name"
}

#--------------------------------------------------------------------------------
#Route table
#-----------

variable "allow_all_ipv4_cidr" {
  type          = string
  default       = "0.0.0.0/0"
  description   = "Allow all IPv4 addresses"
}

variable "gateway_id" {
  type          = list(string)  
  description   = "Gateway ID"
}

variable "route_table_name" {
  type          = list(string)
  default       = ["public", "private"]
  description   = "Public and private route table name"
}

#--------------------------------------------------------------------------------
#Route table association
#-----------------------

variable "public_subnet_ids_count" {
  type          = number
  description   = "Number of public subnets to associate with route table"
}

variable "public_subnet_ids" {
  type          = list(string)
  description   = "IDs of public subnets to associate with route table"
}

variable "webserver_subnet_ids_count" {
  type          = number
  description   = "Number of webserver subnets to associate with route table"
}

variable "webserver_subnet_ids" {
  type          = list(string)
  description   = "IDs of webserver subnets to associate with route table"
}

variable "appserver_subnet_ids_count" {
  type          = number
  description   = "Number of appserver subnets to associate with route table"
}

variable "appserver_subnet_ids" {
  type          = list(string)
  description   = "IDs of appserver subnets to associate with route table"
}

