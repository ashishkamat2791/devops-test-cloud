
  
  #launch configuration
  
  resource "aws_launch_configuration" "media_lc" {
    name_prefix          = "media_lc-"
    image_id             = "${aws_ami_from_instance.buildit_golden.id}"
    instance_type        = "t2.micro"
    security_groups      = ["${aws_security_group.media_private_sg.id}"]
    key_name             = "${aws_key_pair.media_auth.id}"
  
    lifecycle {
      create_before_destroy = true
    }
  }
  
  #ASG 
  
  #resource "random_id" "rand_asg" {
  # byte_length = 8
  #}
  
  resource "aws_autoscaling_group" "media_asg" {
    name                      = "asg-${aws_launch_configuration.media_lc.id}"
    max_size                  = "${var.asg_max}"
    min_size                  = "${var.asg_min}"
    health_check_grace_period = "${var.asg_grace}"
    health_check_type         = "${var.asg_hct}"
    desired_capacity          = "${var.asg_cap}"
    force_delete              = true
    load_balancers            = ["${aws_elb.media_elb.id}"]
  
    vpc_zone_identifier = ["${aws_subnet.media_private1_subnet.id}",
      "${aws_subnet.media_private2_subnet.id}",
    ]
  
    launch_configuration = "${aws_launch_configuration.media_lc.name}"
  
    tag {
      key                 = "Name"
      value               = "media_asg-instance"
      propagate_at_launch = true
    }
  
    lifecycle {
      create_before_destroy = true
    }
  }
  

