variable "region" {}
variable "profile" {}

variable "platform_name" {}

variable "platform_vpc_id" {}

variable "public_subnet_ids" {
  type    = "list"
  default = []
}

variable "private_subnet_ids" {
  type    = "list"
  default = []
}

variable "operator_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "public_cidrs" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "use_spot" {
  default = false
}

variable "use_community" {
  #default = false
}

variable "master_count" {
  default = 1
}

variable "infra_node_count" {
  default = 0
}

variable "compute_node_count" {
  default = 3
}

variable "master_instance_type" {
  default = "m4.xlarge"
}

variable "infra_node_instance_type" {
  default = "m4.large"
}

variable "compute_node_instance_type" {
  default = "m4.large"
}

variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = "string"
  description = "Name of the application"
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

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}
