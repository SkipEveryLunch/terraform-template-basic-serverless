resource "aws_security_group" "lambda" {
  name = "${var.project_name}-lambda-${var.env}"
  tags = {
    Name = "${var.project_name}-lambda-${var.env}"
  }
  // MEMO: VPC内完結、外部通信なし
  ingress = []
  egress  = []
  vpc_id  = var.vpc_id
}
