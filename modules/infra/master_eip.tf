resource "aws_eip" "master" {
  count = "${var.master_count}"

  vpc = true

  tags = "${merge(map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Type", "${var.platform_name}-master",
    "Role", "master"
  ),
    "${module.label.tags}"
    )
  }"
}
