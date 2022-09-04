/*
#--------------------------------------------------------------------------------
#Webserver launch template
#-------------------------

variable "webserver_launch_template_name" {
  type          = string
  default       = "My_webserver_instance_launch_template"
  description   = "Webserver launch template name"
}

variable "webserver_instance_name" {
  type          = string
  default       = "My webserver instance"
  description   = "Webserver instances name"
}

variable "webserver_security_group_ids" {
  type          = list(string)
  description   = "Security group IDs to associate with webserver instances"
}

#--------------------------------------------------------------------------------
#Appserver launch template
#-------------------------

variable "appserver_launch_template_name" {
  type          = string
  default       = "My_appserver_instance_launch_template"
  description   = "Appserver launch template name"
}

variable "appserver_instance_name" {
  type          = string
  default       = "My appserver instance"
  description   = "Appserver instances name"
}

variable "appserver_security_group_ids" {
  type          = list(string)
  description   = "Security group IDs to associate with appserver instances"
}

#--------------------------------------------------------------------------------
#Webserver autoscaling group
#---------------------------

variable "webserver_asg_name" {
  type          = string
  default       = "My webserver ASG"
  description   = "Webserver autoscaling group name"
}

variable "webserver_subnet_ids" {
  type          = list(string)
  description   = "Webserver subnets to launch EC2 instances"
}

variable "webserver_target_group_arn" {
  type          = list(string)
  description   = "Public ALB target group arn"
}

#--------------------------------------------------------------------------------
#Appserver autoscaling group
#---------------------------

variable "appserver_asg_name" {
  type          = string
  default       = "My appserver ASG"
  description   = "Appserver autoscaling group name"
}

variable "appserver_subnet_ids" {
  type          = list(string)
  description   = "Appserver subnets to launch EC2 instances"
}

variable "appserver_target_group_arn" {
  type          = list(string)
  description   = "Private ALB target group arn"
}

#--------------------------------------------------------------------------------
#Autoscaling policy for webserver and appserver autoscaling groups
#-----------------------------------------------------------------

variable "policy_names" {
  type          = list(string)
  default       = ["my-web-asg-policy", "my-app-asg-policy"]
  description   = "Autoscaling policy names for webserver and appserver ASG"
}

variable "adjust_type" {
  type          = string
  default       = "ChangeInCapacity"
  description   = "Autoscaling adjustment type"
}

variable "scale_adjustment" {
  type          = number
  default       = 1
  description   = "Number of instances to adjust"
}

variable "scale_cooldown" {
  type          = number
  default       = 120
  description   = "Scaling policy cooldown"
}

#--------------------------------------------------------------------------------
#Cloudwatch metric for autoscaling policies
#------------------------------------------

variable "alarm_description" {
  type          = string
  default       = "Monitors CPU utilization for webserver and appserver ASGs"
  description   = "Cloudwatch alarm description"
}

variable "alarm_name" {
  type          = string
  default       = "my-asg-alarm"
  description   = "Cloudwatch alarm name"
}

variable "operator" {
  type          = string
  default       = "GreaterThanOrEqualToThreshold"
  description   = "Cloudwatch alarm metric operation"
}

variable "cloudwatch_namespace" {
  type          = string
  default       = "AWS/EC2"
  description   = "Cloudwatch namespace"
}

variable "metric" {
  type          = string
  default       = "CPUUtilization"
  description   = "Cloudwatch metric name"
}

variable "threshold" {
  type          = string
  default       = "60"
  description   = "Cloudwatch metric threshold"
}

variable "evaluation_times" {
  type          = string
  default       = "2"
  description   = "Number of consecutive evaluations"
}

variable "evaluation_time" {
  type          = string
  default       = "120"
  description   = "Evaluation time"
}

variable "stats" {
  type          = string
  default       = "Average"
  description   = "Statistics used"
}

*/

#--------------------------------------------------------------------------------
#Bastion host
#------------

variable "bastion_host_name" {
  type          = string
  default       = "My bastion host"
  description   = "Bastion hosts name"
}

variable "bastion_security_group_id" {
  type          = list(string)
  description   = "Security group ID to associate with bastion host"
}

variable "bastion_host_key" {
  type          = string
  default       = "My bastion host key"
  description   = "Bastion host key pair"
}

variable "bastion_public_key" {
  type          = string
  default       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCRUcUfjzvjJdDNZ5yBVldrffQAnLFtLweywwc940jH5fWJ3NztgG/nvlFJKDc/qpn2idC6BFB1NK7jvNucBDY3sC1+PrJlT2xywf/DmpCUjnMz/AEyBSfwZvICgKfKTE6rXx2VqAE6rURggXjY1gwyNWxIIvcrOu0mrd+Ctf3nvSKou2bF6/9xk0HZ88kq4gwuarDwqHBIuyuM6glfMjcgl9rxhFQLW+GVolGPdBN4pPNXCUeEzRNwooIVOkQlQCpSpMbwLyZS+c5ohfLp6zlYGk57BX/614s8BS7z6w+s2qwOhbRyhrOx7ffTWmtYqMwLatuwD9Lms3vpMmOmJKL5"
  description   = "Public key of bastion hosts to SSH"
}

variable "bastion_subnet_id" {
  type          = string
  description   = "Subnet ID for bastion host"
}

variable "connection_type" {
  type          = string
  default       = "ssh"
  description   = "Bastion host connection type for file provisioner"
}

variable "connection_user" {
  type          = string
  default       = "ec2-user"
  description   = "Bastion host user for file provisioner"
}

#--------------------------------------------------------------------------------
#EKS cluster
#-----------

variable "cluster_subnet_ids" {
  type          = list(string)
  description   = "Subnet IDs for EKS cluster"
}

#--------------------------------------------------------------------------------
#EKS node groups
#---------------

variable "webserver_subnet_ids" {
  type          = list(string)
  description   = "Webserver subnets to launch EC2 instances"
}

variable "appserver_subnet_ids" {
  type          = list(string)
  description   = "Appserver subnets to launch EC2 instances"
}

variable "worker_node_public_key" {
  type          = string
  default       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCKL0VOx5se/OClRd83X4+pZgHRdA7ET7o9LZIAepGIaJBWo/FZiLQ76wzXv2NT0CEMS1q5OMvwb8mOC6ab9BJcKWVnxWMdvLiiBYmnfdtFtpg3S31vTt03berIwml7cAfviU/aZsVzyNyKqrhLLtLNCgsq/zWMwjXdVek9J6QOev7OLie2UnXRn0TpJesMxlObzwQ6Dps6ANI4j0uewxGO2m/kkEqwnkAuw8pv3dfqMomVjhmXAdCerxceKFUXrh7BmEIB5q4/h68wgz25iu6b/tp8D8xCvdqs/PQ99LEd8fdb5k/F7UQW+3SUIjqbd5zjWFBa3p63zvm2sJ1BNKwn"
  description   = "Public key of private instances to SSH"
}

variable "worker_nodes_security_group_ids" {
  type          = list(string)
  description   = "Security group for worker nodes"
}

variable "worker_node_key" {
  type          = string
  default       = "My worker node key"
  description   = "My worker node key pair"
}

#--------------------------------------------------------------------------------
#Common variables
#----------------

variable "resource_type" {
  type          = string
  default       = "instance"
  description   = "Type of resource in launch template"
}

variable "instance_ami" {
  type          = string
  description   = "AMI of private EC2 instances"
}

variable "instance_type" {
  type          = string
  description   = "Private EC2 instance type"
}

variable "health_check_type" {
  type          = string
  default       = "ELB"
  description   = "Health check type for EC2 instances in VPC"
}

variable "min_instance_count" {
  type          = number
  description   = "Minimum number of EC2 instances in ASG"
}

variable "desired_instance_count" {
  type          = number
  description   = "Desired number of EC2 instances in ASG"
}

variable "max_instance_count" {
  type          = number
  description   = "Maximum number of EC2 instances in ASG"
}

variable "private_subnet_key" {
  type          = string
  default       = "My private instance key"
  description   = "Private instance key pair"
}

variable "public_key" {
  type          = string
  default       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCKL0VOx5se/OClRd83X4+pZgHRdA7ET7o9LZIAepGIaJBWo/FZiLQ76wzXv2NT0CEMS1q5OMvwb8mOC6ab9BJcKWVnxWMdvLiiBYmnfdtFtpg3S31vTt03berIwml7cAfviU/aZsVzyNyKqrhLLtLNCgsq/zWMwjXdVek9J6QOev7OLie2UnXRn0TpJesMxlObzwQ6Dps6ANI4j0uewxGO2m/kkEqwnkAuw8pv3dfqMomVjhmXAdCerxceKFUXrh7BmEIB5q4/h68wgz25iu6b/tp8D8xCvdqs/PQ99LEd8fdb5k/F7UQW+3SUIjqbd5zjWFBa3p63zvm2sJ1BNKwn"
  description   = "Public key of private instances to SSH"
}

