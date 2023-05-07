packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "aws-linux" {
  ami_name      = "linux-aws"
    source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name = "*amzn2-ami-hvm-x86_64-*"
    }
    owners = ["amazon"]  
    most_recent = true
  }
  instance_type = "t2.micro"
  region        = "us-east-1"
  vpc_filter {
    filters = {
      "isDefault" : "false",
    }
  }
  subnet_id    = "subnet-08a31227cf13a4fb5"
  ssh_username = "ec2-user"
}

build {
  hcp_packer_registry {
    bucket_name = "aws-us-east1-amazon-linux2-dev"
    description = "AWS-Linux-"
    bucket_labels = {
      "owner"          = "Compute Team"
      "os"             = "Linux",
    }
  }
  sources = [
    "source.amazon-ebs.aws-linux",
  ]
}
