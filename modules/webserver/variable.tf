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
variable BastionUserData {
  type        = string
  default = null
}
variable key_name {

}
variable webservercount {
}
