# Auto Scaling Group for Web Server Tier
resource "aws_autoscaling_group" "webasg" {

    name                 = "web_tier_autoscalinggroup"
    max_size             = var.asg_max
    min_size             = var.asg_min
    launch_configuration = var.web_launch_config
    target_group_arns    = [var.out_tg_instances]
    force_delete         = true
    vpc_zone_identifier  = [var.public_subnet1,var.public_subnet2]
    health_check_type    = "EC2"
    health_check_grace_period = 300

}