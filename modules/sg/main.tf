resource "aws_security_group" "PoC-Bastion_Host_SG" {
  name = "PoC-Bastion_Host_SG"
  description = "Security group for bastion host"
  vpc_id = var.myvpcid
  ingress = [
    {
      protocol  = "tcp"
      self      = false
      from_port = 22
      to_port   = 22
      description = "Allow bastion Host to ssh"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Outbound Rule"
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      self      = false
      security_groups = null
    }
  ]
}
resource "aws_security_group" "PoC-Internal-SG" {
  vpc_id = var.myvpcid
  name = "PoC-Internal-SG"
  description = "Security group for Internal communication"
  ingress = [
    {
      protocol  = "-1"
      self      = true
      from_port = 0
      to_port   = 0
      description = "SG for InterCommunication"
      cidr_blocks = []
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = ""
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      self      = false
      security_groups = null
    }
  ]
}
resource "aws_security_group" "PoC-Web_Server_SG" {
  vpc_id = var.myvpcid
  name = "PoC-Web_Server_SG"
  description = "Security group for http request"
  ingress = [
    {
      protocol  = "tcp"
      self      = false
      from_port = 80
      to_port   = 80
      description = "Rule for WebSerer"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "test"
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      self      = false
      security_groups = null
    }
  ]
}
