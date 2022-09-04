variable "bucket_prefix" {
  type          = list(string)
  default       = ["public-bucket", "private-bucket"]
  description   = "Bucket name prefix"
}

variable "vpc_id" {
  type          = string
  description   = "VPC ID"
}

variable "service_name" {
  type          = string
  default       = "com.amazonaws.us-east-1.s3"
  description   = "VPC endpoint service name"
}

variable "route_table_ids" {
  type          = list(string)
  description   = "Route table IDs"
}

variable "subnet_cidrs" {
  type          = list(string)
  description   = "Subnet CIDRs to deny private bucket access"
}
