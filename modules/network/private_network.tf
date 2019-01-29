# Private subnet: for instances / internal lb

# For Outbound access
locals {
  private_subnet_count = "${length(data.aws_availability_zones.available.names)}"
}

resource "aws_subnet" "private" {
  count             = "${local.private_subnet_count}"
  vpc_id            = "${aws_vpc.platform.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block        = "${cidrsubnet(aws_vpc.platform.cidr_block, 3, count.index)}"

  map_public_ip_on_launch = true

  tags = "${merge(
    map(
      "kubernetes.io/cluster/${var.platform_name}", "owned",
      "Type", "${var.platform_name}-private-${count.index}"
    ),
      "${module.label.tags}"
    )}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.platform.id}"

  tags = "${merge(map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Type", "${var.platform_name}-private-rt"
  ),
    "${module.label.tags}"
    )}"
}

# Adds Egress Route to RouteTable

resource "aws_route" "private_internet" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.public_gw.id}"
  depends_on             = ["aws_route_table.public"]
}

# RouteTable to Subnet
resource "aws_route_table_association" "private" {
  count          = "${local.private_subnet_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
