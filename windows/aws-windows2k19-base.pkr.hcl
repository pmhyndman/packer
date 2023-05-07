#Packer Windows Test

packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


source "amazon-ebs" "windows-base" {
  ami_name       = "aws-win-2k19-base"
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name = "Windows_Server-2019-English-Full-Base-*"
    }
    owners = ["amazon"]  
    most_recent = true
  }

  instance_type  = "t2.medium"
  region         = "us-east-1"
  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_insecure = "true"
  winrm_use_ntlm = "true"
  winrm_use_ssl  = "true"
  user_data_file = "./windows2k19_bootstrap.txt"
  vpc_filter {
    filters = {
      "isDefault" : "true",
    }
  }
  subnet_id = "subnet-c6c41d8b"
}

build {
  hcp_packer_registry {
    bucket_name = "aws-win-2k19-base"
    description = "Prod"
    bucket_labels = {
      "owner"          = "Compute Team"
      "os"             = "Windows",
      "windows-version" = "Server 2019",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }
 sources = [
    "source.amazon-ebs.windows-base"
  ]

    provisioner "powershell" {
    script = "./password_change.ps1"
  }
}
