
/*resource "null_resource" "localcommand" {
  triggers = {
    filepath = var.filepath
  }
  provisioner "local-exec" {
    when    = destroy
    command = self.triggers.filepath
    interpreter = ["PowerShell", "-Command"]
    environment = {
      filepath = self.triggers.filepath
     }
  }
}*/
resource "aws_instance" "AppServer" {
  count = var.appservercount
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.SecurityGroupID
  key_name               = var.key_name
  subnet_id              = var.subnetID
  user_data              = var.BastionUserData
  tags = {
    Name = var.instance_name
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> infra-details/app-server-ip.txt"
  }
}

output "instance_ids" {
   description = "IDs of EC2 instances"
   value       = aws_instance.AppServer.*.id
 }