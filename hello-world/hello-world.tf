// PROVIDER
provider "aws" {
	region = "us-east-2"
}

// RESOURCES

resource "aws_instance" "hello-world-terraform" {
	ami           = "ami-0c55b159cbfafe1f0"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.hello-world-terraform-security-group.id]
	user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
	tags = {
		Name = "hello-world-terraform"
	}
}

resource "aws_security_group" "hello-world-terraform-security-group" {
	name = "hello-world-security-group"
	ingress {
		from_port   = 8080
		to_port     = 8080
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

// OUTPUTS

output "public_ip" {
	value       = aws_instance.hello-world-terraform.public_ip
	description = "The public IP of the web server"
}
