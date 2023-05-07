packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "aws-ubuntu-20-04-LTS" {
  ami_name = "aws-ubuntu-20-04-LTS"        
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners = ["amazon"]  
    most_recent = true
  }
  instance_type  = "t2.medium"
  region         = "us-east-1"
  ssh_username   = "ubuntu"
  vpc_filter {
    filters = {
      "isDefault" : "true",
    }
  }
  subnet_id = "subnet-c6c41d8b"
}

build {
  hcp_packer_registry {
    bucket_name = "aws-ubuntu-20-04-LTS"
    description = "dev"
    bucket_labels = {
      "owner"           = "Compute Team"
      "os"              = "Ubuntu",
      "linux-version"   = "aws-ubuntu-20-04-LTS",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }
  sources = [
    "source.amazon-ebs.aws-ubuntu-20-04-LTS"
  ]
}