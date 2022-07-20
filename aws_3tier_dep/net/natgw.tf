# NATing the elastic IP to the Gateway Service
resource "aws_eip" "natgwip" {

    vpc = true
  
}

#Resource IDs taken while Gateway Service created
resource "aws_nat_gateway" "natgw" {

    subnet_id     = aws_subnet.publicsubnet2.id
    depends_on    = [aws_internet_gateway.gw]
    allocation_id = aws_eip.natgwip.id


    tags          = {
    Name          = "NAT_To_Internet_Gateway"
    }

  
}

output "output_igw" {
  value          = aws_internet_gateway.gw.id
}