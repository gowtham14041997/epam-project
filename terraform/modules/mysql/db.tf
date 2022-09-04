#--------------------------------------------------------------------------------
#Subnet group for DB instances
#-----------------------------

resource "aws_db_subnet_group" "epam_db_subnet_group" {
  name       = var.db_group
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = var.db_subnet_group_name
  }
}

#--------------------------------------------------------------------------------
#Storing DB user password
#------------------------

resource "random_password" "epam_random" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "mysql-db-password"
}

resource "aws_secretsmanager_secret_version" "db_current_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.epam_random.result
}

data "aws_secretsmanager_secret" "my_db_password" {
  name = "mysql-db-password"
  depends_on = [
    aws_secretsmanager_secret.db_password
  ]
}

data "aws_secretsmanager_secret_version" "my_db_current_password" {
  secret_id = data.aws_secretsmanager_secret.my_db_password.id
  depends_on = [
    data.aws_secretsmanager_secret.my_db_password
  ]
}

#--------------------------------------------------------------------------------
#DB user password rotation
#-------------------------

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "../support_files/lambda_function.py"
  output_path = "../support_files/lambda_function.zip"
}

data "aws_region" "current" {}

resource "aws_lambda_function" "rotate_password" {
  filename         = data.archive_file.lambda_archive.output_path
  function_name    = "password-rotation"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_archive.output_base64sha256
  runtime          = "python3.8"
/*  
  vpc_config {
    subnet_ids         = var.lambda_subnet
    security_group_ids = var.lambda_security_group
  }
*/

  timeout     = 120
  description = "AWS SecretsManager secret rotation for RDS"
  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "s.${data.aws_region.current.name}.amazonaws.com"
    }
  }
}

resource "aws_lambda_permission" "allow_secret_manager_call_lambda" {
  function_name = aws_lambda_function.rotate_password.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-secrets" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda-vpc" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_secretsmanager_secret_rotation" "db_password_rotation" {
  secret_id           = aws_secretsmanager_secret.db_password.id
  rotation_lambda_arn = aws_lambda_function.rotate_password.arn

  rotation_rules {
    automatically_after_days = 7
  }
}

#--------------------------------------------------------------------------------
#DB instances
#------------

resource "aws_db_instance" "epam_dbs_instance" {
  count                     = var.db_instance_count
  db_name                   = var.db_name
  identifier                = "my-mysql-db-${count.index + 1}"
  allocated_storage         = var.db_storage
  db_subnet_group_name      = aws_db_subnet_group.epam_db_subnet_group.name
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_class
  username                  = var.db_user
  password                  = data.aws_secretsmanager_secret_version.my_db_current_password.secret_string
  vpc_security_group_ids    = var.db_security_group_ids
  multi_az                  = true
  skip_final_snapshot       = true
}

