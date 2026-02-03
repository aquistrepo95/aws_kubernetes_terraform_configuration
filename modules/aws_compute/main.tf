/*data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}*/


resource "aws_instance" "kube_server" {
  ami                         = "ami-0c398cb65a93047f2" # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type - us-east-1
  instance_type               = var.instance_type
  subnet_id                   = var.instance_subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.public_ssh_key.key_name
  vpc_security_group_ids      = [ aws_security_group.k8s-master-sg.id ]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("ssh_keys")
    host = self.public_ip
  }

  provisioner "file" {
    source      = "./master.sh"
    destination = "/home/ubuntu/master.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod a+x /home/ubuntu/master.sh",
        "sudo sh /home/ubuntu/master.sh master-node",
    ]  
  }

  tags = merge(
    var.instance_tags,
    {
      Name = "Kube-Server"
    }
  ) 
}



resource "aws_security_group" "k8s-master-sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id_instance

  /*egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }*/

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_egress_rule" "k8s-master-sg-egress" {
  security_group_id = aws_security_group.k8s-master-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all ports
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  description       = "SSH from anywhere"  
  security_group_id = aws_security_group.k8s-master-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_k8s_api_server_ipv4" {
  description       = "Allow K8s API Server for control plane"  
  security_group_id = aws_security_group.k8s-master-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6443
  ip_protocol       = "tcp"
  to_port           = 6443
}

resource "aws_vpc_security_group_ingress_rule" "etcd_server_ipv4" {
  description       = "Allow etcd server communication for control plane"
  security_group_id = aws_security_group.k8s-master-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2379
  ip_protocol       = "tcp"
  to_port           = 2380
}

resource "aws_vpc_security_group_ingress_rule" "kublet_ipv4" {
  description       = "Allow etcd server communication for control plane"  
  security_group_id = aws_security_group.k8s-master-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 10250
  ip_protocol       = "tcp"
  to_port           = 10250
}

resource "aws_vpc_security_group_ingress_rule" "kube-scheduler_ipv4" {
  description       = "Allow kube-scheduler communication for control plane"  
  security_group_id = aws_security_group.k8s-master-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 10259
  ip_protocol       = "tcp"
  to_port           = 10259
}

resource "aws_vpc_security_group_ingress_rule" "kube-controller-manager_ipv4" {
  description       = "Allow kube-controller-manager communication for control plane"  
  security_group_id = aws_security_group.k8s-master-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 10257
  ip_protocol       = "tcp"
  to_port           = 10257
}

resource "aws_key_pair" "public_ssh_key" {
  key_name = "ssh_keys"
  public_key = file("ssh_keys.pub")
}