#--------------------------------------------------------------------------------
#VPC
#---

output "vpc_id" {
    value = aws_vpc.epam_vpc.id
}

output "vpc_cidr" {
    value = split(",", aws_vpc.epam_vpc.cidr_block)
}

#----------------------------------------------------------------------------------
#Public subnet for bastion host
#------------------------------

output "public_subnet_id" {
    value = element(aws_subnet.epam_public_subnet.*.id, 0)
}

output "public_subnet_ids_count" {
    value = length(aws_subnet.epam_public_subnet.*.id)
}

output "public_subnet_ids" {
    value = aws_subnet.epam_public_subnet.*.id
}

output "public_subnet_cidrs" {
    value = aws_subnet.epam_public_subnet.*.cidr_block
}

#----------------------------------------------------------------------------------
#Private subnet for webservers
#-----------------------------

output "webserver_subnet_ids_count" {
    value = length(aws_subnet.epam_webserver_subnet.*.id)
}

output "webserver_subnet_ids" {
    value = aws_subnet.epam_webserver_subnet.*.id
}

output "webserver_subnet_cidrs" {
    value = aws_subnet.epam_webserver_subnet.*.cidr_block
}

#----------------------------------------------------------------------------------
#Private subnet for appservers
#-----------------------------

output "appserver_subnet_ids_count" {
    value = length(aws_subnet.epam_appserver_subnet.*.id)
}

output "appserver_subnet_ids" {
    value = aws_subnet.epam_appserver_subnet.*.id
}

#----------------------------------------------------------------------------------
#DB subnet
#---------

output "db_subnet_ids" {
    value = aws_subnet.epam_db_subnet.*.id
}

output "db_subnet_cidrs" {
    value = aws_subnet.epam_db_subnet.*.cidr_block
}