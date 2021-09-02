resource "aws_key_pair" "devops14_2021" {
  key_name   = "devops14_2021"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3EPyRCVkt2dIkNrz49T+bHC9mf3PStPjHagjQKR3bOcC21vDQG9puJJZ4/vn1tDk1nKqs3N9oVb8DBw+pVJXTw/nzJIVhTwySd2U4UGh2oQpaRFMN9DcqZVwG5J3pRBbEGKdwL9osyv2rgE0F/AkSBGR37Uix+y3IwXe4pugtsxbB+4Eo4FPLR42hbgGmPWdlEvv2zn/5Ri5fAdCiWZ67EHdBBKxI5mWW1sRC2V+C2AGG2BFsGlABdHqw47PIus/lLJSFoZnYkgd7G4Tzu8HRPqYypGWnQI4XQgKUPeF2xXQoJV+ktv5Eqc4fdOkYIoPK7iXA5oZ40xcdbAMtp1CZ root@terraform.local"
}

resource "aws_instance" "devops14_2021-1" {
  ami = var.ami["us-east-1"]
  instance_type = var.instance_type["us-east-1"]
  tags = {
    Name  = "myec2-1"
    Owner = "Aziz"
  }
}

resource "aws_instance" "devops14_2021-2" {
  ami = var.ami["us-east-1"]
  instance_type = var.instance_type["us-east-1"]
  tags = {
    Name  = "myec2-2"
    Owner = "Aziz"
  }
}

resource "aws_instance" "devops14_2021-3" {
  ami = var.ami["us-east-1"]
  instance_type = var.instance_type["us-east-1"]
  tags = {
    Name  = "myec2-3"
    Owner = "Aziz"
  }
}

resource "aws_security_group" "dynamic-sg" {
  name = "devops14_2021-dynamic-sg"
  dynamic "ingress" {
    for_each = var.ingress_ports
    #    iterator = port
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    for_each = var.egress_ports
    #    iterator = port
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.dynamic-sg.id
  network_interface_id = aws_instance.devops14_2021-1.primary_network_interface_id
}

/*
resource "aws_eip" "lb" {
  instance = aws_instance.devops14_2021-1.id
  vpc      = true
}
*/

resource "aws_eip" "elastic_ip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.devops14_2021-1.id
  allocation_id = aws_eip.elastic_ip.id
}
