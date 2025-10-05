data "aws_ami" "amazon" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "load_balancer" {
  name        = "example-1-lb-sg"
  description = "Allow HTTP traffic for load balancer"
  vpc_id      = aws_vpc.example_1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver" {
  name        = "example-1-webserver-sg"
  description = "Allow traffic from Load Balancer and SSH access"
  vpc_id      = aws_vpc.example_1.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "example_1_webserver" {
  name_prefix            = "example-1-webserver-"
  image_id               = data.aws_ami.amazon.id
  instance_type          = var.aws_instance_type
  key_name               = "awsec2"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data              = base64encode(file("webserver.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "example-1-webserver-instance"
    }
  }

  monitoring {
    enabled = true
  }
}

resource "aws_autoscaling_group" "webserver" {
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  vpc_zone_identifier       = aws_subnet.example_1[*].id
  health_check_type         = "EC2"
  health_check_grace_period = 60
  target_group_arns         = [aws_lb_target_group.webserver.arn]

  launch_template {
    id      = aws_launch_template.example_1_webserver.id
    version = "$Latest"
  }
}

resource "aws_lb" "example_1" {
  name               = "example-1-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = aws_subnet.example_1[*].id

  tags = {
    Name = "example-1-lb"
  }
}

resource "aws_lb_target_group" "webserver" {
  name     = "example-1-webserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example_1.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "example-1-webserver-tg"
  }
}

resource "aws_lb_listener" "webserver" {
  load_balancer_arn = aws_lb.example_1.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver.arn
  }
}

resource "aws_autoscaling_policy" "cpu" {
  name                   = "scale-on-cpu"
  autoscaling_group_name = aws_autoscaling_group.webserver.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
