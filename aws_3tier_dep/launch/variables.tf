# Ubuntu EC2 Instances  eu-west-2 Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-06-09
# Used https://cloud-images.ubuntu.com/locator/ec2/ to locate the right image
variable "amis" {
    
    default = "ami-0fb391cce7a602d1f"
  
}

# Selected free tier instance
variable "instance_type_web_tier" {

    default = "t2.micro"
  
}

variable "instance_type_app_tier" {

    default = "t2.micro"
  
}

variable "output_web_sg" {} 
variable "external_alb_sg" {} 
variable "output_bastion_ssh" {}   
variable "output_internal_alb_sg" {}