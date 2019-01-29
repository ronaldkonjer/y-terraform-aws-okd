resource "aws_security_group" "bastion" {
  name        = "${var.platform_name}-bastion"
  description = "Bastion group for ${var.platform_name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.operator_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Type", "${var.platform_name}-bastion",
    "Role", "bastion"
  ),
    "${module.label.tags}"
    )
  }"

  vpc_id = "${data.aws_vpc.platform.id}"
}
