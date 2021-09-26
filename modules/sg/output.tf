output bastionHost {
    value =  aws_security_group.PoC-Bastion_Host_SG.id
}
output InternalSG {
    value =  aws_security_group.PoC-Internal-SG.id
}
output WebServerSG {
    value =  aws_security_group.PoC-Web_Server_SG.id
}