# Auto Scaling Group for Application Server Tier

resource "aws_autoscaling_group" "appasg" {

    name                 = "app_tier_autoscalinggroup"
    max_size             = var.asg_max
    min_size             = var.asg_min
    launch_configuration = var.app_launch_config
    target_group_arns    = [var.in_tg_instances]
    force_delete         = true
    vpc_zone_identifier  = [ var.private_subnet3,var.private_subnet4 ]
    health_check_type    = "EC2"
    health_check_grace_period = 300


  
}