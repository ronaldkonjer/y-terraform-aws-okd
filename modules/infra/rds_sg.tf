resource "aws_security_group" "rds" {
  name        = "${var.platform_name}-rds"
  description = "Cluster rds group for ${var.platform_name}-rds"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["${var.operator_cidrs}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "${var.platform_name}-rds",
    "Role", "rds",
    )}"

  vpc_id = "${data.aws_vpc.platform.id}"
}
