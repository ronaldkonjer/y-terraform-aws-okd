resource "aws_vpc" "platform" {
  cidr_block                       = "${var.platform_cidr}"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = "${merge(
    map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Type", "${var.platform_name}-vpc"
    ),
    "${module.label.tags}"
    )}"
}
