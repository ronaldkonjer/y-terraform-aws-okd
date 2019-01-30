variable "region" {
  description = "The region to deploy the cluster in, e.g: eu-west-1."
}

variable "profile" {
  description = "The .aws credentials profile to use to connect to AWS"
}

variable "platform_name" {}

variable "rh_subscription_pool_id" {
  description = "Red Hat subscription pool id for OpenShift Container Platform"
  default     = ""
}

variable "rhn_username" {
  description = "Red Hat Network login username for registration system of the OpenShift Container Platform cluster"
  default     = ""
}

variable "rhn_password" {
  description = "Red Hat Network login password for registration system of the OpenShift Container Platform cluster"
  default     = ""
}

variable "bastion_ssh_user" {}

variable "bastion_endpoint" {}

variable "platform_private_key" {}

variable "openshift_major_version" {
  default = "3.11"
}

variable "use_community" {
  default = false
}

variable "master_domain" {}

variable "platform_domain" {}

variable "public_certificate_pem" {
  default = ""
}

variable "public_certificate_key" {
  default = ""
}

variable "public_certificate_intermediate_pem" {
  default = ""
}

variable "platform_vpc_id" {}

# todo move to workspace variables
variable "openshift_cluster_admin_users" {
  type    = "list"
  default = ["admin", "developer", "ronald.konjer"]
}

variable "openshift_master_htpasswd_users_vault" {
  type = "list"
}
