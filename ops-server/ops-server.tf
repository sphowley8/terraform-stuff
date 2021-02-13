// PROVIDER

provider "aws" {
        region = "us-east-2"
}

// LOCAL VARIABLES

locals {
	placeholder = "here"
}

// RESOURCES

resource "aws_instance" "ops-server-tf" {
  ami           = data.aws_ami.most-recent-ami-tf.id
  instance_type = "t3.micro"

  tags = {
    Name = "ops-server-tf"
  }
}

// DATA SOURCES
data "aws_instance" "ops-server-tf" {
  depends_on = [aws_instance.ops-server-tf]
  filter {
    name   = "tag:Name"
    values = ["ops-server-tf"]
  }
}

data "aws_ami" "most-recent-ami-tf" {
  most_recent = true
  owners = ["self"]

  filter {
    name   = "tag:Name"
    values = ["personal-server-tf"]
  }
}

// OUTPUTS

output "ops-server-tf_id" {
  value = data.aws_instance.ops-server-tf.id
}

output "ami_id"{
  value = data.aws_ami.most-recent-ami-tf.id 
}
