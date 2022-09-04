#----------------------------------------------------------------------------------
#Subnet group for DB instances
#-----------------------------

variable "db_group" {
  type          = string
  default       = "my-db-subnet-group"
  description   = "DB subnet group"
}

variable "db_subnet_ids" {
  type          = list(string)
  description   = "Subnet IDs to group for mysql cluster"
}

variable "db_subnet_group_name" {
  type          = string
  default       = "My DB subnet group"
  description   = "DB subnet group name"
}

#----------------------------------------------------------------------------------
#DB instances
#------------

variable "db_instance_count" {
  type          = number
  description   = "DB instance count"
}

variable "db_name" {
  type          = string
  default       = "MyDBInstance"
  description   = "DB instance name"
}

variable "db_storage" {
  type          = number
  default       = 10
  description   = "DB storage"
}

variable "db_engine" {
  type          = string
  default       = "mysql"
  description   = "DB engine"
}

variable "db_engine_version" {
  type          = string
  default       = "8.0.27"
  description   = "DB engine version"
}

variable "db_instance_class" {
  type          = string
  default       = "db.t2.micro"
  description   = "DB instance class"
}

variable "db_user" {
  type          = string
  default       = "epamer"
  description   = "DB username"
}

variable "db_security_group_ids" {
  type          = list(string)
  description   = "Security group IDs for DB instances"
}