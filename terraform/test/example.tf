provider "aws" {
  region  = var.region
}

resource "aws_instance" "server" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"

  tags = {
    Name = "web-${var.env}"
    Env  = var.env
  }
}

variable "env" {
  default = "dev"
}

variable "region" {
  default = "us-east-1"
}
