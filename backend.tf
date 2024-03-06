terraform {
  backend "s3" {
    bucket         = "my-tf-bucket"
    key            = "state/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "my-tf-bucket-tf-lock-table"
  }
}