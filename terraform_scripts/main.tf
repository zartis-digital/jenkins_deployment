provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "key_deployer" {
  key_name   = "jenkins_access"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLGGdXWwLxOLg2JKgHrSkJmV+YLG6qZfTw55H33bp+HR3LK5d9Br9tHT1YRrNONuxdSeVfGnJImRGzOzCM3l5Rq/9OI6Nfonb6fmG24sbezOyi4PnoLgQAYDsVJOY80Xnf+iNx3uABJfdspYtErWfYPObiz/rzbj+FnLGzW0+yOkmH54BjBJZ0oAlC8/Po6Qpr4eiBe0HqW5w4wfvgbyisxR0TFHAgM2OpnKXZTb9Dz6vvqYIRecb9v5XplhySExY5ZdrDw/uzJ/RdNJSQEo6Zp4W5g1ndJbPBPAZWXR35f6AZB91gXJP8A85zLjZNjExihQxcEH4UQ6gtibFtn+nn2bg/KYfxEDTwvisCW09ZiD1dl4aG7kmOZiXn1bU4cXVyVl8R7HFKqGhxqZFTUe0Dthk/9DWQHHXFP3VkH0aTXCNxJvVwIngsRJUcAv5A9B2popBiMOxUkut69Phf3BLP8fYBXsGqJbxYYlWCGb1WmLhHB7DiuRG2jjjuu76SPLikVGaFVnDxw8DUuY60apEURJ1ptD630vO9nCPlnD/sCE9pQVEcwfxQqFoGR4OdeCkzymhDJb4lzqKtmXVOWq4scK8/a1FNVMvr+as97hil6fPsMPmYIJmQ7hD73QV86raYf2bM2u1lgrqxdCOhjZWM1zyQMHj+LaA05it7g4HLdQ== andrzej.brozyniak@zartis.com"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0bbe28eb2173f6167"
  instance_type = "t2.micro"
  key_name      = "jenkins_access"
  security_groups = ["jenkins security",]

  tags = {
    Name = "jenkins-instance"
  }

  connection {
        host = self.public_ip
		user = "ubuntu"
		private_key = "${file("~/.ssh/id_rsa")}"
	}

  provisioner "remote-exec" {
		inline = ["sudo apt install -y python"]
  }
}

output "instance_ip_addr" {
  value = aws_instance.jenkins.public_ip
}
