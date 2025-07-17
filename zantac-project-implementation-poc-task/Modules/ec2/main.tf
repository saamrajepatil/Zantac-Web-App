resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = var.key_name
  user_data   = base64encode(file(var.user_data_path))  # removed because Ansible will configure

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Zantac-App-Node"  # Required for Ansible dynamic inventory
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "asg-group"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  vpc_zone_identifier       = var.subnet_ids

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

  tag {
    key                 = "Name"
    value               = "Zantac-App-Node"  # Consistent with LT tag
    propagate_at_launch = true
  }
}
