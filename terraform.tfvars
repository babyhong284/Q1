### general
region       = "ap-southeast-1"
resource_tag = "resource_tag_01"

### network variables
vpc_subnet   = "192.168.0.0/16"
subnet_count = 3

### server variables
bastion_instance_type = "t3.micro"
bastion_ami_id        = "ami-0aa097a5c0d31430a" # Amazon Linux 2023 AMI

appserver_instance_type    = "t3.micro"
appserver_ami_id           = "ami-0aa097a5c0d31430a" # Amazon Linux 2023 AMI
appserver_desired_capacity = 1
appserver_min_size         = 1
appserver_max_size         = 3

appserver_port = 443

### sql variables
mariadb_instance_type = "db.t3.medium"
db_username = "admin"
db_password = "passwordSecure!"
db_storage_size = 20
