# Creating a Internet Gateway Service for VPC KPMG
resource "aws_internet_gateway" "gw" {
        vpc_id = aws_vpc.vpckpmg.id

        tags   = {
        Name   = "Internet_Gateway_KPMG"
        }
  
}
