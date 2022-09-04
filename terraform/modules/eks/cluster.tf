#--------------------------------------------------------------------------------
#EKS cluster
#-----------

resource "aws_eks_cluster" "epam_eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.epam_eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.cluster_subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.my-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.my-cluster-AmazonEKSServicePolicy,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.epam_eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.epam_eks_cluster.certificate_authority.0.data
}

resource "aws_iam_role" "epam_eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "my-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.epam_eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "my-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.epam_eks_cluster_role.name
}

#--------------------------------------------------------------------------------
#EKS webserver node group
#------------------------

resource "aws_key_pair" "worker_node_key" {
  key_name   = var.worker_node_key
  public_key = var.worker_node_public_key
}

resource "aws_eks_node_group" "epam_eks_webserver_node_group" {
  cluster_name    = aws_eks_cluster.epam_eks_cluster.name
  node_group_name = "my-eks-webserver-node-group"
  node_role_arn   = aws_iam_role.epam_eks_nodegroup_role.arn
  subnet_ids      = var.webserver_subnet_ids

  remote_access {
    ec2_ssh_key               = aws_key_pair.worker_node_key.id
    source_security_group_ids = var.worker_nodes_security_group_ids
  }

  scaling_config {
    min_size     = var.min_instance_count
    desired_size = var.desired_instance_count
    max_size     = var.max_instance_count
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.my-eks-nodegroup-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.my-eks-nodegroup-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.my-eks-nodegroup-AmazonEC2ContainerRegistryReadOnly,
  ]
}

#-------------------------------------------------------------------------------
#EKS appserver node group
#------------------------

resource "aws_eks_node_group" "epam_eks_appserver_node_group" {
  cluster_name    = aws_eks_cluster.epam_eks_cluster.name
  node_group_name = "my-eks-appserver-node-group"
  node_role_arn   = aws_iam_role.epam_eks_nodegroup_role.arn
  subnet_ids      = var.appserver_subnet_ids

  remote_access {
    ec2_ssh_key               = aws_key_pair.worker_node_key.id
    source_security_group_ids = var.worker_nodes_security_group_ids
  }
  
  scaling_config {
    min_size     = var.min_instance_count
    desired_size = var.desired_instance_count
    max_size     = var.max_instance_count
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.my-eks-nodegroup-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.my-eks-nodegroup-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.my-eks-nodegroup-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "epam_eks_nodegroup_role" {
  name = "eks-nodegroup-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "my-eks-nodegroup-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.epam_eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "my-eks-nodegroup-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.epam_eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "my-eks-nodegroup-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.epam_eks_nodegroup_role.name
}

#--------------------------------------------------------------------------------
#Bastion host
#------------

resource "aws_key_pair" "bastion_host_key" {
  key_name   = var.bastion_host_key
  public_key = var.bastion_public_key
}

resource "aws_instance" "epam_bastion_host" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bastion_host_key.id
  subnet_id                   = var.bastion_subnet_id
  security_groups             = var.bastion_security_group_id
  associate_public_ip_address = true

  provisioner "file" {
    source      = "../support_files/private_instance_key.pem"
    destination = "/home/ec2-user/private_instance_key.pem"

    connection {
      type        = var.connection_type
      user        = var.connection_user
      private_key = file("../support_files/bastion_key.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = var.bastion_host_name
  }
}
