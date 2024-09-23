# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity   = var.appserver_desired_capacity
  max_size           = var.appserver_max_size
  min_size           = var.appserver_min_size
  vpc_zone_identifier = [ aws_subnet.private[0].id ]
  launch_template {
    id      = aws_launch_template.appserver.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "appserver-asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "appserver" {
  name                   = "appserver"
  image_id               = var.appserver_ami_id
  instance_type          = var.appserver_instance_type
  vpc_security_group_ids = [
    aws_security_group.appserver.id
  ]

  ebs_optimized           = true
  disable_api_termination = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "appserver"
      Resource = var.resource_tag
    }
  }
}
