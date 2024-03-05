terraform {
  #  backend "s3" {
  #    encrypt = true
  #  }
  #}

  backend "s3" {
    bucket         = "my-tf-bucket-5-tfstate"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-tf-bucket-5-tf-lock-table"
  }
}