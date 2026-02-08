resource "aws_subnet" "private_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-subnet-1a-${var.env}"
  }
}
