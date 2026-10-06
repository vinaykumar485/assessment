terraform {
  backend "s3" {
    bucket         = "vinay-terraform-assessment-state-2026"
    key            = "assessment/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
