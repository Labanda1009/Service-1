terraform {
  backend "s3" {
    bucket  = "lovette-state-file"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
