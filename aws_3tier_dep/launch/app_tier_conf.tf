# Application Server(business Logic) Tier Launch Configuration file
# Ubuntu EC2 Instances  eu-west-2 Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-06-09
# Used https://cloud-images.ubuntu.com/locator/ec2/ to locate the right image

resource "aws_launch_configuration" "app-lc" {

    name                       = "App_Tier_Launch_Config"
    image_id                   = var.amis
    instance_type              = var.instance_type_app_tier
    security_groups            = [
                                 var.output_internal_alb_sg,
                                 var.output_bastion_ssh,
                                  ]


    user_data                  = file("./launch/userdefined_app.sh")
    key_name                   = "kpmgkey"
  
}

output "app_lc_name" {
  value = aws_launch_configuration.app-lc.name
}