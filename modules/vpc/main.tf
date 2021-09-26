resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "mypocvpc"
  }
}
resource "aws_subnet" "public_Subnet" {  
    cidr_block = var.public_subnet_cidr
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "publicSubnet"
    }
  
}
resource "aws_subnet" "private_Subnet" {  
    cidr_block = var.private_subnet_cidr
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1a"
    tags = {
        Name = "privateSubnet"
    }
}
resource "aws_internet_gateway" "myigw" {
    tags = {
        Name = "myigw"
    }
    vpc_id = aws_vpc.myvpc.id
}
resource "aws_nat_gateway" "mynet" {
     tags = {
        Name = "mynet"
    }
    depends_on = [aws_eip.genpact-eip,aws_internet_gateway.myigw]
    subnet_id = aws_subnet.public_Subnet.id
    connectivity_type = "public"
    allocation_id = "${aws_eip.genpact-eip.id}"
}
resource "aws_route_table" "Publicrouter" { 
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "Public_Router_Table"
    }
        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.myigw.id
        }
}
resource "aws_route_table" "Privaterouter" { 
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "Privaterouter"
    }
    route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_nat_gateway.mynet.id
        }
        lifecycle {
            ignore_changes = all
        }
}
resource "aws_route_table_association" "route1" {
    subnet_id = "${aws_subnet.public_Subnet.id}"
    route_table_id = "${aws_route_table.Publicrouter.id}"
}
resource "aws_route_table_association" "route2" {
    subnet_id = "${aws_subnet.private_Subnet.id}"
    route_table_id = "${aws_route_table.Privaterouter.id}"
}
resource "aws_subnet" "public_Subnet1" {  
    cidr_block = var.public_subnet_cidr1
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1b"
    tags = {
        Name = "publicSubnet1"
    }
  
}
resource "aws_subnet" "private_Subnet1" {  
    cidr_block = var.private_subnet_cidr1
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1b"
    tags = {
        Name = "privateSubnet1"
    }
}
resource "aws_eip" "genpact-eip" {
  vpc              = false
  lifecycle {
    ignore_changes = all
  }
}

output vpcID {
  value       = "${aws_vpc.myvpc.id}"
  description = "VPC_ID for VPC"
}
output vpcCIRD {
  value       = "${var.vpc_cidr}"
  description = "VPC Cidr for VPC"
}
output PublicSubnetID {
  value       = "${aws_subnet.public_Subnet.id}"
  description = "VPC Cidr for VPC"
}
output PrivateSubnetID {
  value       = "${aws_subnet.private_Subnet.id}"
  description = "VPC Cidr for VPC"
}
output PublicSubnetID1 {
  value       = "${aws_subnet.public_Subnet1.id}"
  description = "VPC Cidr for VPC"
}
output PrivateSubnetID1 {
  value       = "${aws_subnet.private_Subnet1.id}"
  description = "VPC Cidr for VPC"
}
 