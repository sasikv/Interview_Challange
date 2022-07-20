# Creating a BASTION EC2 instance to jump into the East-West traffic and Access the devices there
resource "aws_instance" "bastion" {

    ami                         = var.amis
    instance_type               = var.instance_type
    subnet_id                   = var.public_subnet1
    associate_public_ip_address = true
    key_name                    = "kpmgkey"
    vpc_security_group_ids      = [var.output_bastion_ssh]

    tags                        = {
        Name = "Bastion_JumpIn_for_KPMG_from_Public"
    }
 
    
  
}

#Assigning an elastic IP for the JumpIn Device

resource "aws_eip" "bastion_eip" {

    instance                    = aws_instance.bastion.id
    vpc                         = true
  
}

# Private Subnet EC2 to connect internally from Bastion

resource "aws_instance" "prv_sub_3_instance" {

    ami                         = var.amis
    instance_type               = var.instance_type
    subnet_id                   = var.private_subnet3
    key_name                    = "kpmgkey"
    vpc_security_group_ids      = [
                                  var.output_bastion_ssh,
                                  var.web_access_from_nat_prv_sg
                                  
    ]
    tags                        = {
        Name                    = "Bastion_JumpIn_for_KPMG_on_Subnet3"
    }
  
}

resource "aws_instance" "prv_sub_4_instance" {

    ami                         = var.amis
    instance_type               = var.instance_type
    subnet_id                   = var.private_subnet4
    key_name                    = "kpmgkey"
    vpc_security_group_ids      = [
                                  var.output_bastion_ssh,
                                  var.web_access_from_nat_prv_sg
                                  
    ]
    tags                        = {
        Name                    = "Bastion_JumpIn_for_KPMG_on_Subnet4"
    }
  
}
