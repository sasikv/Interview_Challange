#This file creates a free tier RDS MySql Database instance
resource "aws_db_instance" "rds_kpmg" {

    allocated_storage               = 20
    storage_type                    = "gp2"
    engine                          = "mysql"
    engine_version                  = "8.0.28"
    instance_class                  = "db.t3.micro"
    db_name                         = "rds_kpmg"
    username                        = "admin"
    password                        = "1234abcd"
    multi_az                        = false
    port                            = 3306
    db_subnet_group_name            = var.out_rdssubnetgroup
    vpc_security_group_ids          = [var.rdsmysqlsg]
    tags                            = {
            name                    = "RDS_MySQL_8-0-28_NoAZ_KPMG"
    }

  
}