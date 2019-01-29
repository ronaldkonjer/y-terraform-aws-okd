resource "aws_route53_zone" "private" {
  name = "${var.platform_name}.internal"

  vpc {
    vpc_id = "${data.aws_vpc.platform.id}"
  }

  # tags = "${merge(map(
  #   "kubernetes.io/cluster/${var.platform_name}", "owned"
  #   "Type", "${var.platform_name}-route53-private"
  # ),
  #   "${module.label.tags}"
  #   )
  # }"
}

resource "aws_route53_record" "master" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "master.${var.platform_name}.internal"
  type    = "A"

  alias {
    name                   = "${aws_elb.master.dns_name}"
    zone_id                = "${aws_elb.master.zone_id}"
    evaluate_target_health = false
  }
}
