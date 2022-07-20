# Ubuntu EC2 Instances  eu-west-2 Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-06-09
# Used https://cloud-images.ubuntu.com/locator/ec2/ to locate the right image
variable "amis" {
    
    default = "ami-0fb391cce7a602d1f"
  
}

# Selected free tier instance
variable "instance_type" {

    default = "t2.micro"
  
}

variable "public_subnet1" {}
variable "output_bastion_ssh" {}
variable "private_subnet3" {}
variable "private_subnet4" {}
variable "web_access_from_nat_prv_sg" {}
variable "web_access_from_nat_pub_sg" {}



