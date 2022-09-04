#--------------------------------------------------------------------------------
#Random string to have unique bucket names
#-----------------------------------------

resource "random_string" "random" {
  length           = 10
  special          = false
  upper            = false
}

#--------------------------------------------------------------------------------
#Public s3 buckets
#-----------------

resource "aws_s3_bucket" "epam_public_bucket" {
  count = 2
  bucket = "${element(var.bucket_prefix, 0)}-${count.index + 1}-${random_string.random.result}"
}

#--------------------------------------------------------------------------------
#Private s3 bucket
#-----------------

resource "aws_s3_bucket" "epam_private_bucket" {
  bucket = "${element(var.bucket_prefix, 1)}-${random_string.random.result}"
}

#--------------------------------------------------------------------------------
#Bucket policy for private bucket
#--------------------------------

resource "aws_s3_bucket_policy" "epam_private_bucket_policy" {
  bucket = aws_s3_bucket.epam_private_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "VpcSourceIp",
  "Statement": [
    {
      "Sid": "VpcSourceIp",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.epam_private_bucket.arn}",
        "${aws_s3_bucket.epam_private_bucket.arn}/*"
      ],
      "Condition": {
        "IpAddress": {
          "aws:VpcSourceIp": ["${join("\",\"", var.subnet_cidrs)}"]             
        }
      }
    }
  ]
}
POLICY
}

#--------------------------------------------------------------------------------
#VPC endpoint for S3
#-------------------

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  route_table_ids   = var.route_table_ids
}



