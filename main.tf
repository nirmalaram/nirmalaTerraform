resource "aws_instance" "test"{
    ami = "ami-04ff98ccbfa41c9ad"
    instance_type = "t2.micro"
    key_name = "NVirginia32"
    tags = {
      Name="server3"
    }
}
terraform {
  backend "s3" {
    bucket = "sfbucketmay09"
    key    = "terraform.tf"
    region = "us-east-1"
  }
}
