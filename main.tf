provider "aws" {
  region = "us-east-1"
}
//Module (genpact-poc-vpc") Will be used to provision the security stuff
module "genpact-poc-vpc" {
  source               = "./modules/vpc/"
  vpc_cidr             = "192.168.0.0/26"
  public_subnet_cidr   = "192.168.0.0/28"
  private_subnet_cidr  = "192.168.0.16/28"
  public_subnet_cidr1  = "192.168.0.32/28"
  private_subnet_cidr1 = "192.168.0.48/28"
}
//Module (genpact-poc-sg") Will be used to provision the security group for bastion and internal Communication between multiple host
module "genpact-poc-sg" {
  source         = "./modules/sg/"
  myvpcid          =  module.genpact-poc-vpc.vpcID
}
//Module "genpact-poc-ec2-App-Server" to provision APP EC2 Instance 
module "genpact-poc-ec2-App-Server" {
  source          = "./modules/appserver/"
  depends_on = [module.genpact-poc-sg]
  ami_id          = "ami-087c17d1fe0178315"
  instance_type   = "t2.micro"
  SecurityGroupID = [module.genpact-poc-sg.InternalSG]
  subnetID        = module.genpact-poc-vpc.PrivateSubnetID
  instance_name   = "PoC-AppServer"
  key_name = "Usnv-anshul"
  appservercount = "1"
  #filepath = "Clear-Content "
}
module "genpact-poc-ec2-Web-Server" {
  source          = "./modules/webserver/"
  depends_on = [module.genpact-poc-sg]
  ami_id          = "ami-087c17d1fe0178315"
  instance_type   = "t2.micro"
  SecurityGroupID = [module.genpact-poc-sg.InternalSG]
  subnetID        = module.genpact-poc-vpc.PrivateSubnetID
  instance_name   = "PoC-WebServer"
  key_name = "Usnv-anshul"
  webservercount = "1"
  #filepath = "Clear-Content "
}
module "genpact-poc-bastion_host" {
  source          = "./modules/bastion_host/"
  #depends_on = ["module.genpact-poc-sg","module.genpact-poc-ec2-WebSerer","module.genpact-poc-ec2-App-Server"]
  ami_id          = "ami-087c17d1fe0178315"
  instance_type   = "t2.micro"
  key_name = "Usnv-anshul"
  SecurityGroupID = [module.genpact-poc-sg.bastionHost, module.genpact-poc-sg.InternalSG]
  subnetID        = module.genpact-poc-vpc.PublicSubnetID
  instance_name   = "PoC-BastionHost"
  BastionUser = "${file("credentails/install_userdata.sh")}"
  publicfile  = "${path.module}/credentails/id_rsa"
  privatefile = "${path.module}/credentails/id_rsa.pub"
  privatekey = "${path.module}/credentails/USVN-anshul"
  privateip = "${path.module}/infra-details"
  code =  "${path.module}/application-code"
}
module "genpact-poc-alb" {
  source       = "./modules/loadbalancer/"
  albsg = [module.genpact-poc-sg.WebServerSG,module.genpact-poc-sg.InternalSG]
  albsubnet = [module.genpact-poc-vpc.PublicSubnetID, module.genpact-poc-vpc.PublicSubnetID1]
  albvpc = module.genpact-poc-vpc.vpcID
  alb-tg-target_id = module.genpact-poc-ec2-Web-Server.instance_ids[0]
  depends_on = [module.genpact-poc-sg,module.genpact-poc-ec2-App-Server]
}