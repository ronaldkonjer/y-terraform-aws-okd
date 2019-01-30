variable "region" {
  description = "The region to deploy the cluster in, e.g: eu-west-1."
}

variable "user_secret_profile" {
  description = "The .aws credentials profile to use to connect to AWS"
}

variable "platform_name" {
  description = "The name of the cluster that is used for tagging some resources"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = "dev"
}

variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = "default"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage` and `attributes`"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "valtags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "operator_cidrs" {
  type        = "list"
  default     = ["0.0.0.0/0"]
  description = "CIDRS that is allowed from which master api can be accessed"
}

variable "public_cidrs" {
  type        = "list"
  default     = ["0.0.0.0/0"]
  description = "CIDRS that is allowed from which public users can access served services in the cluster"
}

variable "use_spot" {
  default = false
}

variable "master_count" {
  default = 1
}

variable "compute_node_count" {
  default = 3
}

variable "master_instance_type" {
  default = "m4.xlarge"
}

variable "compute_node_instance_type" {
  default = "m4.large"
}

variable "use_community" {
  description = "Sets true if you want to install OKD."
  default     = true
}

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

# Domains

variable "platform_domain" {
  description = "Public DNS subdomain for access to services served in the cluster"
  default     = ""
}

variable "platform_domain_administrator_email" {
  default = ""
}

variable "route53_zone_public_id" {
  default = "ZE8PQ2NX2YNDL"
}

variable "openshift_cluster_admin_users" {
  type = "list"
}

variable "openshift_master_htpasswd_users_vault" {
  type = "list"
}
