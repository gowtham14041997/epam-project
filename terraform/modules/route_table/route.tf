#--------------------------------------------------------------------------------
#Internet gateway
#----------------

resource "aws_internet_gateway" "epam_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.igw_name
  }
}

#--------------------------------------------------------------------------------
#NAT gateway
#-----------

resource "aws_eip" "epam_eip_natgw" {
  vpc = true
}

resource "aws_nat_gateway" "epam_natgw" {
  allocation_id = aws_eip.epam_eip_natgw.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = var.natgw_name
  }
}

#--------------------------------------------------------------------------------
#Route table
#-----------

resource "aws_route_table" "epam_route_table" {
    vpc_id = var.vpc_id
    count   = length(var.gateway_id)

    route {
        cidr_block = var.allow_all_ipv4_cidr
        gateway_id = element(var.gateway_id, count.index)
    }

    tags = {
        Name = "My ${element(var.route_table_name, count.index)} route table"
    }
}

#--------------------------------------------------------------------------------
#Public route table association
#------------------------------

data "aws_route_table" "public_route_table_id" {
  filter {
    name = "tag:Name"
    values = ["My public route table"]
  }
  depends_on = [
    aws_route_table.epam_route_table
  ]
}

resource "aws_route_table_association" "epam_public_route_table_association" {
  count          = var.public_subnet_ids_count
  subnet_id      = element(var.public_subnet_ids, count.index)
  route_table_id = data.aws_route_table.public_route_table_id.id
}

#--------------------------------------------------------------------------------
#Private route table association
#-------------------------------

data "aws_route_table" "private_route_table_id" {
  filter {
    name = "tag:Name"
    values = ["My private route table"]
  }
  depends_on = [
    aws_route_table.epam_route_table
  ]
}

resource "aws_route_table_association" "epam_webserver_route_table_association" {
  count          = var.webserver_subnet_ids_count
  subnet_id      = element(var.webserver_subnet_ids, count.index)
  route_table_id = data.aws_route_table.private_route_table_id.id
}

resource "aws_route_table_association" "epam_appserver_route_table_association" {
  count          = var.appserver_subnet_ids_count
  subnet_id      = element(var.appserver_subnet_ids, count.index)
  route_table_id = data.aws_route_table.private_route_table_id.id
}