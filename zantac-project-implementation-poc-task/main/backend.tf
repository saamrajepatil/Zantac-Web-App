terraform {
  backend "s3" {
    bucket         = "zantac-project-terraform-state"
    key            = "zantac/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "zantac-tf-locks"
    encrypt        = true
  }
}
