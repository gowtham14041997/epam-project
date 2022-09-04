output "webserver_security_group_id" {
    value = split(",", aws_security_group.epam_webserver_security_group.id)
}

output "appserver_security_group_id" {
    value = split(",", aws_security_group.epam_appserver_security_group.id)
}

output "bastion_security_group_id" {
    value = split(",", aws_security_group.epam_bastion_security_group.id)
}

output "db_security_group_id" {
    value = split(",", aws_security_group.epam_db_security_group.id)
}

output "worker_nodes_security_group_id" {
    value = split(",", aws_security_group.epam_worker_nodes_security_group.id)
}

