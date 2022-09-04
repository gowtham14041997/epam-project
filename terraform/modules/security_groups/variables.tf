#--------------------------------------------------------------------------------
#Webserver security group
#------------------------

variable "webserver_security_group" {
  type          = string
  default       = "EPAM webserver security group"
  description   = "EPAM webserver security group"
}

variable "webserver_security_group_name" {
  type          = string
  default       = "My webserver security group"
  description   = "Webserver security group name"
}

variable "webserver_security_group_description" {
  type          = string
  default       = "Security group for webserver instances"
  description   = "Webserver security group description"
}

#--------------------------------------------------------------------------------
#Appserver security group
#------------------------

variable "appserver_security_group" {
  type          = string
  default       = "EPAM appserver security group"
  description   = "EPAM appserver security group"
}

variable "appserver_security_group_name" {
  type          = string
  default       = "My appserver security group"
  description   = "Appserver security group name"
}

variable "appserver_security_group_description" {
  type          = string
  default       = "Security group for appserver instances"
  description   = "Appserver security group description"
}

variable "private_ingress_http_cidr" {
  type          = list(string)
  description   = "Private security group ingress http cidr"
}


#--------------------------------------------------------------------------------
#Bastion security group
#----------------------

variable "bastion_security_group" {
  type          = string
  default       = "EPAM bastion security group"
  description   = "EPAM bastion security group"
}

variable "bastion_security_group_name" {
  type          = string
  default       = "My bastion security group"
  description   = "Bastion security group name"
}

variable "bastion_security_group_description" {
  type          = string
  default       = "Security group for bastion hosts"
  description   = "Bastion security group description"
}

#--------------------------------------------------------------------------------
#Worker nodes security group
#---------------------------

variable "worker_nodes_security_group" {
  type          = string
  default       = "EPAM worker nodes security group"
  description   = "EPAM worker nodes security group"
}

variable "worker_nodes_security_group_name" {
  type          = string
  default       = "My worker nodes security group"
  description   = "Worker nodes security group name"
}

variable "worker_nodes_security_group_description" {
  type          = string
  default       = "Security group for worker nodes"
  description   = "Worker nodes security group description"
}

#--------------------------------------------------------------------------------
#DB security group
#-----------------

variable "db_security_group" {
  type          = string
  default       = "EPAM DB security group"
  description   = "EPAM DB security group"
}

variable "db_security_group_name" {
  type          = string
  default       = "My DB security group"
  description   = "DB security group name"
}

variable "db_security_group_description" {
  type          = string
  default       = "Security group for DB instances"
  description   = "DB security group description"
}

#--------------------------------------------------------------------------------
#Common variables
#----------------

variable "vpc_id" {
  type          = string
  description   = "VPC ID"
}

variable "egress_rules_port" {
  type = number
  default = 0
  description = "Security group egress rules port"	
}

variable "egress_rules_protocol" {
  type = string
  default = "-1"
  description = "Security group egress rules protocol"	
}

variable "allow_all_ipv4_cidr" {
  type          = list(string)
  default       = ["0.0.0.0/0"]
  description   = "Allow all IPv4 addresses"
}

variable "ssh_port" {
  type = number
  default    = 22
  description = "SSH port"	
}

variable "http_port" {
  type = number
  default    = 80
  description = "HTTP port"	
}

variable "mysql_port" {
  type = number
  default    = 3306
  description = "mysql port"	
}

variable "tcp_protocol" {
  type = string
  default    = "tcp"
  description = "TCP protocol"	
}

variable "bastion_private_ip" {
  type          = string
  description   = "Private IP of bastion host"
}