#--------------------------------------------------------------------------------
#VPC
#---

variable "vpc_cidr" {
  type          = string
  description   = "VPC CIDR"
}

variable "tenancy" {
  type          = string
  default       = "default"
  description   = "Instance tenancy"
}

variable "vpc_name" {
  type          = string
  default       = "My VPC"
  description   = "VPC name"
}

#--------------------------------------------------------------------------------
#AZs for public, private and DB subnets
#--------------------------------------

variable "subnet_az" {
  type          = list(string)
  default       = ["us-east-1a", "us-east-1b"]
  description   = "AZs for public and private subnets"
}

#----------------------------------------------------------------------------------
#Public subnet for bastion host
#------------------------------

variable "public_subnet_cidr" {
  type          = list(string)
  default       = ["10.0.1.0/24"]
  description   = "public subnet CIDR"
}

variable "public_subnet_name" {
  type          = string
  default       = "My public subnet"
  description   = "public subnet name"
}


#----------------------------------------------------------------------------------
#Private subnet for webservers
#-----------------------------

variable "webserver_subnet_cidr" {
  type          = list(string)
  default       = ["10.0.2.0/24", "10.0.3.0/24"]
  description   = "Webserver subnet CIDR"
}

variable "webserver_subnet_name" {
  type          = string
  default       = "My webserver subnet"
  description   = "Webserver subnet name"
}

#----------------------------------------------------------------------------------
#Private subnet for appservers
#-----------------------------

variable "appserver_subnet_cidr" {
  type          = list(string)
  default       = ["10.0.4.0/24", "10.0.5.0/24"]
  description   = "Appserver subnet CIDR"
}

variable "appserver_subnet_name" {
  type          = string
  default       = "My appserver subnet"
  description   = "Appserver subnet name"
}

#----------------------------------------------------------------------------------
#DB subnet
#---------

variable "db_subnet_cidr" {
  type          = list(string)
  default       = ["10.0.6.0/24", "10.0.7.0/24"]
  description   = "DB subnet CIDR"
}

variable "db_subnet_name" {
  type          = string
  default       = "My DB subnet"
  description   = "DB subnet name"
}