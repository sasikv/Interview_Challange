# Web Server  Tier Launch Configuration file
# Ubuntu EC2 Instances  eu-west-2 Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-06-09
# Used https://cloud-images.ubuntu.com/locator/ec2/ to locate the right image

resource "aws_launch_configuration" "web-lc" {

    name                       = "Web_Tier_Launch_Config"
    image_id                   = var.amis
    instance_type              = var.instance_type_web_tier
    security_groups            = [
                                 var.external_alb_sg,
                                 var.output_bastion_ssh,
                                 var.output_web_sg
                                  ]

    associate_public_ip_address = true
    user_data                  = file("./launch/userdefined_web.sh")
    key_name                   = "kpmgkey"
  
}

output "web_lc_name" {
  value = aws_launch_configuration.web-lc.name
}

