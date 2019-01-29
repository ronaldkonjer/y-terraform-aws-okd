module "remote-state" {
  source                     = "../..//modules/remote-state"
  region                     = "${var.region}"
  profile                    = "${var.user_secret_profile}"
  project                    = "${var.platform_name}"
  environment                = "${var.stage}"
  create_dynamodb_lock_table = "true"
  create_s3_bucket           = "true"

  shared_aws_account_ids = [
    #"807891339983",
    "158613094363",
  ] # iam
}

module "network" {
  source        = "../../modules/network"
  region        = "${var.region}"
  profile       = "${var.user_secret_profile}"
  platform_name = "${var.platform_name}"
  name          = "${var.platform_name}"
  namespace     = "${var.namespace}"
  stage         = "${var.stage}"
  tags          = "${var.valtags}"
}

module "infra" {
  source        = "../../modules/infra"
  region        = "${var.region}"
  profile       = "${var.user_secret_profile}"
  platform_name = "${var.platform_name}"
  namespace     = "${var.namespace}"
  stage         = "${var.stage}"
  name          = "${var.platform_name}"
  tags          = "${var.valtags}"
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
  region                              = "${var.region}"
  profile                             = "${var.user_secret_profile}"
  platform_name                       = "${var.platform_name}"
  platform_domain                     = "${var.platform_domain}"
  platform_domain_administrator_email = "${var.platform_domain_administrator_email}"
  public_lb_arn                       = "${module.infra.public_lb_arn}"
  route53_zone_public_id              = "${var.route53_zone_public_id}"
}

module "rds_cluster_aurora_mysql" {
  source = "../../modules/rds_cluster_aurora"

  # region         = "${var.region}"
  # profile        = "${var.user_secret_profile}"
  engine = "aurora"

  engine_version = "5.6.10a"
  cluster_family = "aurora5.6"
  cluster_size   = "2"
  namespace      = "${var.namespace}"
  stage          = "${var.stage}"
  name           = "${var.platform_name}"
  tags           = "${var.valtags}"
  admin_user     = "hybris67"
  admin_password = "hybris67"
  db_name        = "hybris67"
  instance_type  = "db.t2.medium"
  vpc_id         = "${module.network.platform_vpc_id}"

  # security_groups = ["${module.infra.rds_security_group}"]
  subnets = ["${module.network.private_subnet_ids}"]
  zone_id = "${module.domain.public_zone_id}"

  cluster_parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_connection"
      value = "utf8"
    },
    {
      name  = "character_set_database"
      value = "utf8"
    },
    {
      name  = "character_set_results"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    },
    {
      name = "lower_case_table_names"

      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "skip-character-set-client-handshake"
      value        = "1"
      apply_method = "pending-reboot"
    },
  ]
}

module "elasticache_cluster" {
  source          = "../../modules/elasticache_cluster"
  region          = "${var.region}"
  profile         = "${var.user_secret_profile}"
  namespace       = "${var.namespace}"
  stage           = "${var.stage}"
  name            = "${var.platform_name}"
  tags            = "${var.valtags}"
  subnets         = ["${module.network.private_subnet_ids}"]
  cluster_id      = "redis-cluster"
  node_groups     = 3
  platform_vpc_id = "${module.network.platform_vpc_id}"
}

module "openshift" {
  source                  = "../../modules/openshift"
  region                  = "${var.region}"
  profile                 = "${var.user_secret_profile}"
  platform_name           = "${var.platform_name}"
  use_community           = "${var.use_community}"
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
