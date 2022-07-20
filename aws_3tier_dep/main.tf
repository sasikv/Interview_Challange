provider "aws" {
    region     = var.region
    profile = var.aws_profile
}

#This module is for creating all network related items like VPC, SG, Routing tables, Gateways, NAT

module "net" {
  source = "./net"
 
  
}

# This module to Create a Fortified Jump In (bastion) host to access internal EC2s
module "bastion" {
  source                      = "./bastion"
  public_subnet1              = module.net.outputpublicsubnet1
  private_subnet3             = module.net.outputprivatesubnet3
  private_subnet4             = module.net.outputprivatesubnet4
  output_bastion_ssh          = module.net.output_bastion_ssh
  web_access_from_nat_prv_sg  = module.net.web_access_from_nat_prv_sg
  web_access_from_nat_pub_sg  = module.net.web_access_from_nat_pub_sg
  
}

# This module is to create RDS MySql Database 
module "database" {
  source                      = "./database"
  private_subnet3             = module.net.outputprivatesubnet3
  private_subnet4             = module.net.outputprivatesubnet4
  out_rdssubnetgroup          = module.net.out_rdssubnetgroup
  rdsmysqlsg                  = module.net.rdsmysqlsg
  
}

# This module is to create launching Configurations of Web and App(Busines Logic) tiers
module "launch" {
  source                  = "./launch"
  output_web_sg           = module.net.output_web_sg
  external_alb_sg         = module.net.output_external_alb_sg
  output_bastion_ssh      = module.net.output_bastion_ssh
  output_internal_alb_sg  = module.net.output_internal_alb_sg

}

#This module is to create Load Balancers
module "loadbalancer" {
  source          = "./loadbalancer"

  public_subnet1  = module.net.outputpublicsubnet1
  public_subnet2  = module.net.outputpublicsubnet2
  private_subnet3 = module.net.outputprivatesubnet3
  private_subnet4 = module.net.outputprivatesubnet4
  vpc_id          = module.net.output_vpc_id
  external_alb_sg = module.net.output_external_alb_sg
  internal_alb_sg = module.net.output_internal_alb_sg
 
  
}

#This module is to create Auto Scaling Groups
module "autoscaling" {
  source            = "./autoscaling"
  web_launch_config = module.launch.web_lc_name
  app_launch_config = module.launch.app_lc_name
  public_subnet1    = module.net.outputpublicsubnet1
  public_subnet2    = module.net.outputpublicsubnet2
  private_subnet3   = module.net.outputprivatesubnet3
  private_subnet4   = module.net.outputprivatesubnet4
  out_tg_instances  = module.loadbalancer.out_tg_instances
  in_tg_instances   = module.loadbalancer.in_tg_instances
}
