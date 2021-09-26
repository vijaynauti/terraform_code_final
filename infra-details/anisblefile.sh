#!/bin/bash
sleep 40
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
sudo yum install dos2unix -y
dos2unix /home/ec2-user/infra-details/app-server-ip.txt
dos2unix /home/ec2-user/infra-details/web-server-ip.txt
cat /home/ec2-user/infra-details/app-server-ip.txt > /home/ec2-user/infra-details/ipdetails
cat /home/ec2-user/infra-details/web-server-ip.txt >> /home/ec2-user/infra-details/ipdetails
#sudo /bin/dos2unix /home/ec2-user/privateip
sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg
for i in `cat /home/ec2-user/infra-details/ipdetails`; do ssh-agent bash -c "ssh-add /home/ec2-user/key.pem; ssh-copy-id -i /root/.ssh/id_rsa.pub -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ec2-user@"$i""; done
echo "[webserver]" > /etc/ansible/hosts
for i in `cat /home/ec2-user/infra-details/web-server-ip.txt`; do echo $i "ansible_ssh_user=ec2-user" >> /etc/ansible/hosts; done
echo "[appserver]" >>/etc/ansible/hosts
for i in `cat /home/ec2-user/infra-details/app-server-ip.txt`; do echo $i "ansible_ssh_user=ec2-user" >> /etc/ansible/hosts; done
sleep 10

/usr/bin/ansible-playbook /home/ec2-user/application-code/ansible-playbook/webserver_installation.yml