provider "aws" {
  region     = var.region
}

module "my_vpc" {
  source                = "../modules/vpc"

  #VPC
  vpc_cidr              = "10.0.0.0/16"

  #Public subnet CIDR for bastion host
  public_subnet_cidr    = slice(var.subnet_cidrs, 0, 2)

  #Private subnet CIDR for web-servers
  webserver_subnet_cidr = slice(var.subnet_cidrs, 2, 4)

  #Private subnet CIDR for app-servers
  appserver_subnet_cidr = slice(var.subnet_cidrs, 4, 6)

  #Private subnet CIDR for mysql
  db_subnet_cidr        = slice(var.subnet_cidrs, 6, 8)
}

module "my_route_table" {
  source                      = "../modules/route_table"

  #VPC ID for internet gateway
  vpc_id                      = module.my_vpc.vpc_id

  #Public subnet for NAT gateway
  public_subnet_id            = module.my_vpc.public_subnet_id
  
  #Gateway IDs to create public and private route table
  gateway_id                  = [module.my_route_table.igw_id, module.my_route_table.natgw_id]

  #Public subnets to be associated with public route table
  public_subnet_ids_count     = module.my_vpc.public_subnet_ids_count
  public_subnet_ids           = module.my_vpc.public_subnet_ids

  #Private subnets to be associated with private route table
  webserver_subnet_ids_count  = module.my_vpc.webserver_subnet_ids_count
  webserver_subnet_ids        = module.my_vpc.webserver_subnet_ids

  #Private subnets to be associated with private route table
  appserver_subnet_ids_count  = module.my_vpc.appserver_subnet_ids_count
  appserver_subnet_ids        = module.my_vpc.appserver_subnet_ids
}

module "my_security_group" {
  source                      = "../modules/security_groups"

  #VPC ID to create public and private security group
  vpc_id                      = module.my_vpc.vpc_id

  #Public subnet CIDR for SSH into private instances
  bastion_private_ip          = module.my_eks_cluster.bastion_ip

  #VPC CIDR block For HTTP into private instances
  private_ingress_http_cidr   = module.my_vpc.vpc_cidr
}

module "my_eks_cluster" {
  source                         = "../modules/eks"

  #Subnet IDs for EKS cluster and node groups
  cluster_subnet_ids             = concat(module.my_vpc.webserver_subnet_ids, module.my_vpc.appserver_subnet_ids)
  webserver_subnet_ids           = module.my_vpc.webserver_subnet_ids
  appserver_subnet_ids           = module.my_vpc.appserver_subnet_ids 

  #Number of instances in webserver and appserver node groups
  min_instance_count             = 1
  desired_instance_count         = 2
  max_instance_count             = 3

  #EKS workers nodes security group to SSH into
  worker_nodes_security_group_ids = module.my_security_group.worker_nodes_security_group_id

  #Bastion host
  instance_ami                   = "ami-090fa75af13c156b4"
  instance_type                  = "t2.micro"
  bastion_security_group_id      = module.my_security_group.bastion_security_group_id
  bastion_subnet_id              = module.my_vpc.public_subnet_id
}

module "my_db" {
  source                      = "../modules/mysql"

  #Subnet IDs to group for DB instances
  db_subnet_ids               = module.my_vpc.db_subnet_ids 

  #DB instance configuration
  db_instance_count           = 2
  db_engine                   = "mysql"
  db_instance_class           = "db.t2.micro"
  db_security_group_ids       = module.my_security_group.db_security_group_id
}

module "my_s3_buckets" {
  source                  = "../modules/s3"

  #VPC ID for VPC end point
  vpc_id                  = module.my_vpc.vpc_id

  #Route table IDs to associate with VPC end point
  route_table_ids         = [module.my_route_table.public_route_table_id, module.my_route_table.private_route_table_id]

  #Subnet CIDRs to restrict private bucket access
  subnet_cidrs            = concat(module.my_vpc.public_subnet_cidrs, module.my_vpc.webserver_subnet_cidrs, module.my_vpc.db_subnet_cidrs)
}

