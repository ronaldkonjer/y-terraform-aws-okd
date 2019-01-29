resource "aws_lb" "public" {
  name                             = "${var.platform_name}-public"
  internal                         = false
  load_balancer_type               = "network"
  subnets                          = ["${var.public_subnet_ids}"]
  enable_cross_zone_load_balancing = true

  tags = "${merge(map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Type", "${var.platform_name}-public"
  ),
    "${module.label.tags}"
    )
  }"
}

data "dns_a_record_set" "platform_public_ip_set" {
  host = "${aws_lb.public.dns_name}"
}
