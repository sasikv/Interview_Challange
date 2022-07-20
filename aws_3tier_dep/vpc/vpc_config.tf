# Creating a VPC for KPMG Project Demo
resource "aws_vpc" "vpckpmg" {
    cidr_block = var.vpc_cdir_block

    tags = {
        Name = "VPC KPMG"
    }
  
}
output "output_vpc_id" {
  value = aws_vpc.vpckpmg.id
}

# Creating a Public Subnet 1 under KPMG VPC
resource "aws_subnet" "publicsubnet1" {
    
    vpc_id            = aws_vpc.vpckpmg.id
    cidr_block        = var.public_subnet_1
    availability_zone = var.availability_zone_A

    tags              = {
    Name              = "Public_Subnet_1_KPMG"
    }
  
}

output "outputpublicsubnet1" {
  value = aws_subnet.publicsubnet1.id
}

# Creating a Public Subnet 2 under KPMG VPC
resource "aws_subnet" "publicsubnet2" {
    
    vpc_id            = aws_vpc.vpckpmg.id
    cidr_block        = var.public_subnet_2
    availability_zone = var.availability_zone_B

    tags              = {
    Name              = "Public_Subnet_2_KPMG"
    }
  
}

output "outputpublicsubnet2" {
  value              = aws_subnet.publicsubnet2.id
}

# Creating a Private Subnet 3 under KPMG VPC

resource "aws_subnet" "privatesubnet3" {
    
    vpc_id            = aws_vpc.vpckpmg.id
    cidr_block        = var.private_subnet_3
    availability_zone = var.availability_zone_A

    tags              = {
    Name              = "Private_Subnet_3_KPMG"
    }
  
}

output "outputprivatesubnet3" {
  value = aws_subnet.privatesubnet3.id
}


# Creating a Public Subnet 4 under KPMG VPC

resource "aws_subnet" "privatesubnet4" {
    
    vpc_id            = aws_vpc.vpckpmg.id
    cidr_block        = var.private_subnet_4
    availability_zone = var.availability_zone_B

    tags              = {
    Name              = "Private_Subnet_4_KPMG"

    }
  
}

output "outputprivatesubnet4" {
  value = aws_subnet.privatesubnet4.id
}

# Creating a seperate Subnet Group for RDS Databases - Accessible for private Subnets

resource "aws_db_subnet_group" "rdsubnetgroup" {
    
    name             = "rds_subnet_group"
    subnet_ids       = [aws_subnet.privatesubnet3.id, aws_subnet.privatesubnet4.id]

    tags             = {

    name             = "Subnet_Group_RDS_KPMG"
    }
  
}

output "out_rdssubnetgroup" {
  value = aws_db_subnet_group.rdsubnetgroup.id
}
