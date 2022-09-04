output "webserver_asg_id" {
  value = aws_eks_node_group.epam_eks_webserver_node_group.resources[0].autoscaling_groups[0].name
}

output "appserver_asg_id" {
  value = aws_eks_node_group.epam_eks_appserver_node_group.resources[0].autoscaling_groups[0].name
}

output "bastion_ip" {
  value = aws_instance.epam_bastion_host.private_ip
}