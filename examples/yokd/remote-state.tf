# module "remote-state" {
#   source                     = "../..//modules/remote-state"
#   region                     = "${var.region}"
#   profile                    = "${var.user_secret_profile}"
#   project                    = "${var.platform_name}"
#   environment                = "${var.stage}"
#   create_dynamodb_lock_table = "true"
#   create_s3_bucket           = "true"
#   shared_aws_account_ids = [
#     #"807891339983",
#     "158613094363",
#   ] # iam
# }

