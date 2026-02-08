resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  // MEMO: VPC内完結（外部通信なし）のため、ローカルルートのみ

  tags = {
    Name = "${var.project_name}-rtb-private-${var.env}"
  }
}

resource "aws_route_table_association" "private_1a" {
  route_table_id = aws_route_table.private.id
  subnet_id      = var.subnet_id
}
