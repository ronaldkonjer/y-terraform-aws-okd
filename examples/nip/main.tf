module "network" {
  source        = "../../modules/network"
  platform_name = "${var.platform_name}"
}

module "infra" {
  source = "../../modules/infra"

  platform_name = "${var.platform_name}"
  use_community = "${var.use_community}"

  platform_vpc_id    = "${module.network.platform_vpc_id}"
  public_subnet_ids  = ["${module.network.public_subnet_ids}"]
  private_subnet_ids = ["${module.network.private_subnet_ids}"]

  operator_cidrs = ["${var.operator_cidrs}"]
  public_cidrs   = ["${var.public_cidrs}"]

  use_spot = "${var.use_spot}"

  master_count               = "${var.master_count}"
  master_instance_type       = "${var.master_instance_type}"
  compute_node_count         = "${var.compute_node_count}"
  compute_node_instance_type = "${var.compute_node_instance_type}"
}

module "domain" {
  source                              = "../../modules/domain"
  platform_name                       = "${var.platform_name}"
  platform_domain                     = "${var.platform_domain}"
  platform_domain_administrator_email = "${var.platform_domain_administrator_email}"
  public_lb_arn                       = "${module.infra.public_lb_arn}"
  route53_zone_public_id              = "${var.route53_zone_public_id}"
}

module "openshift" {
  source = "../../modules/openshift"

  platform_name = "${var.platform_name}"
  use_community = "${var.use_community}"

  bastion_ssh_user        = "${module.infra.bastion_ssh_user}"
  bastion_endpoint        = "${module.infra.bastion_endpoint}"
  platform_private_key    = "${module.infra.platform_private_key}"
  rhn_username            = "${var.rhn_username}"
  rhn_password            = "${var.rhn_password}"
  rh_subscription_pool_id = "${var.rh_subscription_pool_id}"

  master_domain = "${module.infra.master_domain}"

  #platform_domain = "${element(module.infra.platform_public_ip_set, 0)}.nip.io"
  platform_domain = "${var.platform_domain}"
  platform_vpc_id = "${module.network.platform_vpc_id}"
}

# module "rds_cluster_aurora_mysql" {
#   source          = "../../modules/rds_cluster_aurora"
#   engine          = "aurora"
#   cluster_family  = "aurora-mysql5.7"
#   cluster_size    = "2"
#   namespace       = "default"
#   stage           = "dev"
#   name            = "${var.platform_name}-hybris67"
#   admin_user      = "hybris67"
#   admin_password  = "hybris67"
#   db_name         = "hybris67"
#   instance_type   = "db.t2.medium"
#   vpc_id          = "${module.network.platform_vpc_id}"
#   security_groups = ["${module.infra.rds_security_group}"]
#   subnets         = ["${module.network.private_subnet_ids}"]
#   zone_id         = "${module.domain.public_zone_id}"


#   cluster_parameters = [
#     {
#       name  = "character_set_client"
#       value = "utf8"
#     },
#     {
#       name  = "character_set_connection"
#       value = "utf8"
#     },
#     {
#       name  = "character_set_database"
#       value = "utf8"
#     },
#     {
#       name  = "character_set_results"
#       value = "utf8"
#     },
#     {
#       name  = "character_set_server"
#       value = "utf8"
#     },
#     {
#       name  = "collation_connection"
#       value = "uft8_bin"
#     },
#     {
#       name  = "collation_server"
#       value = "uft8_bin"
#     },
#     {
#       name         = "lower_case_table_names"
#       value        = "1"
#       apply_method = "pending-reboot"
#     },
#     {
#       name         = "skip-character-set-client-handshake"
#       value        = "1"
#       apply_method = "pending-reboot"
#     },
#   ]
# }

