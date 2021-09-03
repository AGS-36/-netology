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

locals {
    instance_type_map = {
        stage = "t3.micro"
        prod = "t3.large"
    }[terraform.workspace]
    
    instance_count_map = {
        stage = 1
        prod = 2
    }[terraform.workspace]

    instances = {
    stage =    {
      "t2.nano" = data.aws_ami.ubuntu.id
    }
    prod = {
    "t2.micro" = data.aws_ami.ubuntu.id
    "t2.nano" = data.aws_ami.ubuntu.id
    }[terraform.workspace]
}

resource "aws_instance" "test" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type_map
  count = local.instance_count_map

  tags = {
    Name = "Ubuntu"
  }
}

resource "aws_instance" "test-amazon" {
  for_each = local.instances
  ami = each.value
  instance_type = each.key

  lifecycle {
    create_before_destroy = true
  }
}
