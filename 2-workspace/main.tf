provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-0c7217cdde317cfec"
  # instance_type = "t2.micro"

  instance_type = (
    terraform.workspace == "default" ? "t3.medium" : "t3.micro"
  )
}

terraform {
  backend "s3" {
    bucket         = "feb14-terraform-state"
    key            = "workspaces-example/terraform.tfstate"
    dynamodb_table = "terraform-state"
    region         = "us-east-1"
    encrypt        = true
  }
}