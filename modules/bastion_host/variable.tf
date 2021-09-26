variable ami_id {
  type        = string
}
variable instance_type {
  type        = string
}
variable SecurityGroupID {
}
variable subnetID {
  type        = string
}
variable instance_name {
  type        = string
}
variable BastionUser {
  type        = string
  default = null
}
variable publicfile {
  type        = string
}
variable privatefile {
  type        = string
}
/*variable serverip {
  type        = string
}
variable ansiblecon {
  type        = string
}*/
variable privateip {
  type        = string
}
variable privatekey {
  type        = string
}

variable key_name {
  type        = string
}

variable code {
  type        = string
}