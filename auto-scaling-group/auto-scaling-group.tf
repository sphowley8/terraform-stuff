// PROVIDER

provider "aws" {
        region = "us-east-2"
}

// RESOURCES

// Launch Template
resource "aws_launch_template" "personal-server-template-tf" {
  name_prefix   = "personal-server-template-tf"
  image_id      = "ami-0c8a821193b81d3a8"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = ["sg-080a7be96c9bb7b3d"]
}

// Auto-Scaling Group
resource "aws_autoscaling_group" "personal-server-tf" {
  availability_zones = ["us-east-2a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = "${aws_launch_template.personal-server-template-tf.id}"
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "dadada"
    propagate_at_launch = false
  }

  tag {
    key = "Division"
    value = "finance"
    propagate_at_launch = true
  }

}

// DATA SOURCES
data "aws_instance" "instance-data" {
  filter {
    name   = "tag:Division"
    values = ["finance"]
  }
}

// OUTPUTS

output "personal-server-template-tf_id" {
  value = "${aws_launch_template.personal-server-template-tf.id}"
}

output "instance-test-tf_iid" {
  value = "${data.aws_instance.instance-data.id}"
}

