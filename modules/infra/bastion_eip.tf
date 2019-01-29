resource "aws_eip" "bastion" {
  vpc = true

  tags = "${merge(map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Type", "${var.platform_name}-bastion",
    "Role", "bastion"
    ),
    "${module.label.tags}"
    )
  }"
}
