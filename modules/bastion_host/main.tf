resource "aws_instance" "Bastion_host" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.SecurityGroupID
  key_name               = var.key_name
  subnet_id              = var.subnetID
  user_data              = var.BastionUser
  tags = {
    Name = var.instance_name
  }
  provisioner "file" {
    source      = var.privatekey
    destination = "/home/ec2-user/key.pem"
  }
  provisioner "file" {
    source      = var.publicfile
    destination = "/home/ec2-user/id_rsa.pub"
  }
  provisioner "file" {
    source      = var.privatefile
    destination = "/home/ec2-user/id_rsa"
  }
  provisioner "file" {
    source      = var.privateip
    destination = "/home/ec2-user/"
  }
  provisioner "file" {
    source      = var.code
    destination = "/home/ec2-user/"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo /bin/chmod +x /home/ec2-user/infra-details/anisblefile.sh",
      "sudo /bin/sh /home/ec2-user/infra-details/anisblefile.sh",
    ]
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file(var.privatekey)}"
    host = self.public_ip
  }
}

