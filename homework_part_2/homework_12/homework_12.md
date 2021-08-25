файл main.tf
https://github.com/AGS-36/devops-netology/blob/master/homework_part_2/homework_12/main.tf
```
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  ipv6_address_count = 1
  cpu_core_count = 1

  tags = {
    Name = "netology"
  }
}
```
файл versions.tf
https://github.com/AGS-36/devops-netology/blob/master/homework_part_2/homework_12/versions.tf
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```
файл outputs.tf
https://github.com/AGS-36/devops-netology/blob/master/homework_part_2/homework_12/outputs.tf

```
output "region_name" {
  value = data.aws_region.current.name
}
output "private_ip" {
 value = data.aws_instance.current.private_ip
}
output "subnet_id" {
 value = data.aws_instance.current.subnet_id
}
```
Можно создать при помощи консоли AWS


