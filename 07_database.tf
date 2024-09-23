resource "aws_db_subnet_group" "rds_group" {
  name       = "mariadb-subnet-group"
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Name = "mariadb-subnet-group"
  }
}

resource "aws_db_instance" "primary-maria" {
  identifier              = "primary-mariadb-instance"
  engine                  = "mariadb"
  engine_version          = "10.5"
  auto_minor_version_upgrade  = false
  instance_class          = var.mariadb_instance_type
  allocated_storage       = var.db_storage_size 
  storage_type            = "gp2"  # General Purpose SSD
  db_subnet_group_name    = aws_db_subnet_group.rds_group.name
  vpc_security_group_ids  = [aws_security_group.db.id]

  multi_az                = true
  backup_retention_period = var.db_backup_retention_period
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true

  tags = {
    Name = "PrimaryMariaDBInstance"
    Resource = var.resource_tag
  }
}


resource "aws_db_instance" "replica-maria" {
  replicate_source_db         = aws_db_instance.primary-maria.identifier
  auto_minor_version_upgrade  = false
  backup_retention_period     = var.db_backup_retention_period
  identifier                  = "maria-replica"
  instance_class              = var.mariadb_instance_type
  skip_final_snapshot         = true

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }

  tags = {
    Name = "ReplicaMariaDBInstance"
    Resource = var.resource_tag
  }
}
