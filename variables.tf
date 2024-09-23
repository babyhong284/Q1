# general
variable "region" {
  type    = string
}
variable "resource_tag" {
  description = "resource tag for all the resources created from terraform"
  type        = string
}

# subnet
variable "vpc_subnet" {
  type    = string

  validation {
    condition     = can(cidrhost(var.vpc_subnet, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}

variable "subnet_count" {
  type = number
  description = "subnets to create, this include a public and private subnet"
}

# bastion
variable "bastion_instance_type" {
  description = "instance type of bastion host"
}
variable "bastion_ami_id" {
  description = "ami id of bastion host"
}

# appserver
variable "appserver_desired_capacity" {}
variable "appserver_min_size" {}
variable "appserver_max_size" {}
variable "appserver_instance_type" {
  description = "instance type of appserver host"
}
variable "appserver_ami_id" {
  description = "ami id of appserver host"
}
variable "appserver_port" {
  description = "application port"
}



# sql
variable "mariadb_instance_type" {
  description = "instance type of mariadb"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "db_storage_size" {
  description = "Database storage size"
  type        = number
}

variable "db_backup_retention_period" {
  description = "Retention period for mariadb"
  type        = number
  default     = 7

  validation {
    condition     = can(var.db_backup_retention_period > 0)
    error_message = "the retention cannot be 0, read replica require at least one backup to work."
  }

}