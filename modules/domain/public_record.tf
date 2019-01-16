resource "aws_route53_record" "master_public" {
  zone_id = "${var.route53_zone_public_id}"
  name    = "${var.platform_domain}"
  type    = "A"

  alias {
    name                   = "${data.aws_lb.public.dns_name}"
    zone_id                = "${data.aws_lb.public.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "public" {
  zone_id = "${var.route53_zone_public_id}"
  name    = "*.${var.platform_domain}"
  type    = "A"

  alias {
    name                   = "${data.aws_lb.public.dns_name}"
    zone_id                = "${data.aws_lb.public.zone_id}"
    evaluate_target_health = false
  }
}
