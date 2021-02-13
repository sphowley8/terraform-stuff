// PROVIDER

provider "aws" {
        region = "us-east-2"
}

// LOCAL VARIABLES

locals {
  timestamp = timestamp()
  timestamp-no-colons = replace(local.timestamp, ":", "")
  ami-name = join("", ["personal-server-tf-", local.timestamp-no-colons])
}

// RESOURCES

// Copy ami

resource "aws_ami_copy" "personal-server-ami-copy1-tf" {
  name              = data.aws_ami.personal-server-ami-tf.name
  description       = join("", ["A copy of ", local.ami-name])
  source_ami_id     = data.aws_ami.personal-server-ami-tf.id
  source_ami_region = "us-east-2"

  tags = {
    Name = "personal-server-tf"
  }
}

// Create ami
resource "aws_ami_from_instance" "personal-server-ami-tf" {
  name               = local.ami-name
  source_instance_id = data.aws_instance.personal-server-tf.id
  depends_on = [aws_ami_copy.personal-server-ami-copy1-tf] 
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "personal-server-tf"
  }
}

// DATA SOURCES

data "aws_instance" "personal-server-tf" {
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

output "personal-server-tf_id" {
  value = data.aws_instance.personal-server-tf.id
}
output "ami-name" {
  value = local.ami-name
}
output "ami-id" {
  value = data.aws_ami.personal-server-ami-tf.id
}
output "ami-name-copy1" {
  value = data.aws_ami.personal-server-ami-tf.name
}

