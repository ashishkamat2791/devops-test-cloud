 #load balancer
  
  resource "aws_elb" "buildit_elb" {
    name = "${var.domain_name}-elb"
  
    subnets = ["${aws_subnet.media_public1_subnet.id}",
      "${aws_subnet.media_public2_subnet.id}",
    ]
  
    security_groups = ["${aws_security_group.media_public_sg.id}"]
  
    listener {
      instance_port     = 80
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
  
    health_check {
      healthy_threshold   = "${var.elb_healthy_threshold}"
      unhealthy_threshold = "${var.elb_unhealthy_threshold}"
      timeout             = "${var.elb_timeout}"
      target              = "TCP:80"
      interval            = "${var.elb_interval}"
    }
  
    cross_zone_load_balancing   = true
    idle_timeout                = 400
    connection_draining         = true
    connection_draining_timeout = 400
  
    tags {
      Name = "media_${var.domain_name}-elb"
    }
  }