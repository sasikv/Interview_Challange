# Bastion Host Security Configurations
# Allow inward port SSH and block all outward ports for any IP

resource "aws_security_group" "bastion_ssh_all_sg_kpmg" {
    
    name            = "bastion_ssh_all_sg_kpmg"
    description     = "Allow SSH Port from Anywhere"
    vpc_id          = aws_vpc.vpckpmg.id 

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.any_ip]
    }

    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = [var.any_ip]

    }

    tags            = {
        
    Name            = "Bastion_Allow_All_KPMG"
    }

     
  
}

output "output_bastion_ssh" {
  value = aws_security_group.bastion_ssh_all_sg_kpmg.id
}

## SSH from Bastion JumpIn Host

resource "aws_security_group" "bastion_ssh_from_nat" {
    name             = "ssh_from_bastion_nat"
    description      = "Allow SSH from Bastion Host"
    vpc_id           = aws_vpc.vpckpmg.id 

    ingress {
     from_port       = 22
     to_port         = 22
     protocol        = "tcp"
     security_groups = [
                        aws_security_group.bastion_ssh_all_sg_kpmg.id,
                        aws_security_group.web_from_nat_prv_sg.id

     ]
    }
  
}

output "bastion_ssh_from_nat" {
  value = aws_security_group.bastion_ssh_from_nat.id
}


# External Traffic coming towards ALB(Application Load Balancer) should be allowed for web access ports

resource "aws_security_group" "external_alb_sg" {
    
    name        = "external_alb_sg"
    description = "Allow port for web access from Anywhere"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.any_ip]
    }

  #ingress {
  #      from_port   = 443
   #     to_port     = 443
   #     protocol    = "tcp"
   #     cidr_blocks = [var.any_ip]
  #  }

    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = [var.any_ip]

    }

    tags            = {
        
    Name            = "External Load Balancer Security Group"
    }

    vpc_id          = aws_vpc.vpckpmg.id 
  
}

output "output_external_alb_sg" {
  value = aws_security_group.external_alb_sg.id
}

# Internal Security Group for Application Load Balancer

resource "aws_security_group" "internal_alb_sg" {
    
    name        = "internal_alb_sg"
    description = "Allow port 3000 from Private"

    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = [var.private_subnet_3]
    }

      ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = [var.private_subnet_4]
    }

    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = [var.private_subnet_3]

    }

     egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = [var.private_subnet_4]

    }

    tags            = {
        
    Name            = "Internal Load Balancer Security Group"
    }

    vpc_id          = aws_vpc.vpckpmg.id 
  
}

output "output_internal_alb_sg" {
  value = aws_security_group.internal_alb_sg.id
}

# Outbound denial for all ports  from anywhere

resource "aws_security_group" "web_outbound_sg" {

    name            = "web_outbound"
    description     = "Allow Outbound Connections"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.any_ip]
    }

    vpc_id          = aws_vpc.vpckpmg.id
  
}

output "output_web_sg" {
  value = aws_security_group.web_outbound_sg.id
}


## Allowing http & https Access to Private Subnet from NAT Instance

resource "aws_security_group" "web_from_nat_prv_sg" {

    name                    = "private_subnet_web_access"
    description             = "Allow 80 & 443 Access to Private Subnet from NAT Instance"
    vpc_id                  = aws_vpc.vpckpmg.id

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.privatesubnet3.cidr_block]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.privatesubnet3.cidr_block]
    }

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = [aws_subnet.privatesubnet3.cidr_block]
    }

       ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.privatesubnet4.cidr_block]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.privatesubnet4.cidr_block]
    }

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = [aws_subnet.privatesubnet4.cidr_block]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = -1
        cidr_blocks     = [var.any_ip]
    }

    tags = {
        Name = "Private Subnet 80 & 443 Access From NAT"
    }
  
}

output "web_access_from_nat_prv_sg" {
  value = aws_security_group.web_from_nat_prv_sg.id
}

## Allowing http & https Access to Private Subnet from Public Subnet via NAT Instance


resource "aws_security_group" "web_from_nat_pub_sg" {

    name                    = "public_subnet_web_access"
    description             = "Allow http & https Access to Private Subnet from Public Subnet via NAT Instance"
    vpc_id                  = aws_vpc.vpckpmg.id

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.publicsubnet1.cidr_block]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.publicsubnet1.cidr_block]
    }

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = [aws_subnet.publicsubnet1.cidr_block]
    }

       ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.publicsubnet2.cidr_block]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.publicsubnet2.cidr_block]
    }

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = [aws_subnet.publicsubnet2.cidr_block]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = -1
        cidr_blocks     = [var.any_ip]
    }

    tags = {
        Name = "Public Subnet http & https Access via NAT to private subnet"
    }
  
}

output "web_access_from_nat_pub_sg" {
  value = aws_security_group.web_from_nat_pub_sg.id
}


# Default MySql port 3306 access given for Private Subnets 3 and 4

resource "aws_security_group" "databasesg" {

    name                    = "database_security_group"
    description             = "Allow db ports to RDS MySQL"
    vpc_id                  = aws_vpc.vpckpmg.id

     ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.privatesubnet3.cidr_block]
    }

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = [aws_subnet.privatesubnet3.cidr_block]
    }

      ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        cidr_blocks     = [aws_subnet.privatesubnet4.cidr_block]
    }

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = [aws_subnet.privatesubnet4.cidr_block]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = -1
        cidr_blocks     = [var.any_ip]
    }

    tags = {
        Name = "RDS MySQL Security Group for KPMG"
    }
  
}

output "rdsmysqlsg" {
  value = aws_security_group.databasesg.id
}



