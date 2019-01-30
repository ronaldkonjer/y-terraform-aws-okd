provider "aws" {
  profile = "${var.user_secret_profile}"
  region  = "${var.region}"
}
