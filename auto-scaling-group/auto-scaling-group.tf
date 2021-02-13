// PROVIDER

provider "aws" {
        region = "us-east-2"
}

// LOCAL VARIABLES

locals {
  eip-id = "eipalloc-08b8832bc5c6c8c1e"
}

// RESOURCES

// Associate elastic IP
resource "aws_eip_association" "personal-server-eip-assoc-tf" {
  depends_on = [aws_autoscaling_group.personal-server-tf]
  instance_id   = data.aws_instance.personal-server-tf.id 
  // Seperated the EIP to prevent it from changing every time the resources are created.
  allocation_id = local.eip-id
}


// Launch Template
resource "aws_launch_template" "personal-server-template-tf" {
  name_prefix   = "personal-server-template-tf"
  image_id      = data.aws_ami.personal-server-ami-tf.id
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
    id      = aws_launch_template.personal-server-template-tf.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "personal-server-tf"
    propagate_at_launch = true
  }

}

// DATA SOURCES
data "aws_instance" "personal-server-tf" {
  depends_on = [aws_autoscaling_group.personal-server-tf]
  filter {
    name   = "tag:Name"
    values = ["personal-server-tf"]
  }
}

data "aws_ami" "personal-server-ami-tf" {
  most_recent = true
  owners = ["self"]

  filter {
    name   = "tag:Name"
    values = ["personal-server-tf"]
  }
}

// OUTPUTS

output "personal-server-template-tf_id" {
  value = aws_launch_template.personal-server-template-tf.id
}

output "personal-server-tf_id" {
  value = data.aws_instance.personal-server-tf.id
}

output "aws-eip-public-id" {
  value = local.eip-id 
}
output "ami_id"{
  value = data.aws_ami.personal-server-ami-tf.id 
}
