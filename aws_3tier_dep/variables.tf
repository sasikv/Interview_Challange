#Setting London as AZ
variable "region" {

    default = "eu-west-2"
  
}

#Using default credential configured in AWSCLI
variable "aws_profile" {

    default = "default"
  
}