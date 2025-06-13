resource "aws_instance" "nat-gw_ubuntu" {
  ami               = "ami-004364947f82c87a0"
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.jsrs-az1-pub1.id
  private_ip        = var.nat_gw_private_ip
  source_dest_check = false
  key_name          = var.ssh_keypair_name
  vpc_security_group_ids = [
    aws_security_group.sec_grp-public.id
  ]
  user_data = <<-EOF
                #!/bin/bash
                echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
                sysctl -p

                export DEBIAN_FRONTEND=noninteractive
                echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
                echo iptables-persistent iptables-persistent/autosave_v6 boolean false | debconf-set-selections

                apt-get update -y
                apt-get install -y iptables-persistent nftables

                iptables -t nat -A POSTROUTING -o enX0 -s 0.0.0.0/0 -j MASQUERADE
                netfilter-persistent save
                nft list ruleset | tee /etc/nftables.conf > /dev/null

                systemctl enable nftables
                systemctl start nftables
                EOF
  tags = {
    Name = "NAT_GW-Ubuntu"
  }
}
# Elastic IP For NAT Gateway
resource "aws_eip" "nat-gw-eip" {
  instance = aws_instance.nat-gw_ubuntu.id
  domain   = "vpc"

  tags = {
    Name = "nat-gw-eip"
  }
}
/* TEST INSTANCE TEARDOWN
resource "aws_instance" "priv_ubuntu" {
  ami           = "ami-004364947f82c87a0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.jsrs-az1-priv1.id
  private_ip    = var.priavte-vm_private_ip
  key_name      = var.ssh_keypair_name
  vpc_security_group_ids = [
    aws_security_group.sec_grp-private.id
  ]
  tags = {
    Name = "PRIVATE-Ubuntu"
  }
}
*/
# Route NAT Gateway
resource "aws_route" "nat-ngw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  network_interface_id   = aws_instance.nat-gw_ubuntu.primary_network_interface_id
  destination_cidr_block = "0.0.0.0/0"
}
