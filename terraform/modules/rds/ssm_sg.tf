
resource "aws_security_group" "ssm" {
  name        = "allow_ssm"
  description = "Allow SSM traffic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ssm_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ssm.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssm_egress" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssm.id
}
