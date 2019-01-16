resource "aws_rds_cluster" "default" {
  engine = "aurora"

  s3_import {
    source_engine         = "mysql"
    source_engine_version = "5.7"
    bucket_name           = "sliceoflife-yhybris-media"
    bucket_prefix         = "backups"
    ingestion_role        = "arn:aws:iam::158613094363:user/s3-user"
  }
}

# resource "aws_db_subnet_group" "rds" {
#   name        = "${var.platform_name}"
#   description = "${var.platform_name}"
#   subnet_ids  = ["${var.private_subnet_ids}"]
#   tags {
#     Name        = "${var.platform_name}-rds"
#   }
# }
# resource "aws_rds_cluster" "rds" {
#   cluster_identifier      = "${var.platform_name}"
#   vpc_security_group_ids = ["${aws_security_group.rds.id}"]
#   db_subnet_group_name    = "${aws_db_subnet_group.rds.name}"
#   engine_mode             = "serverless"
#   database_name           = "hybris67"
#   master_username         = "hybris67"
#   master_password         = "hybris67"
#   backup_retention_period = 1
#   skip_final_snapshot     = true
#   port            = 3306
#   scaling_configuration {
#     auto_pause               = true
#     max_capacity             = 256
#     min_capacity             = 2
#     seconds_until_auto_pause = 300
#   }
#   lifecycle {
#     ignore_changes = [
#       "engine_version",
#     ]
#     #prevent_destroy = true
#   }
# }

