terraform {
  backend "s3" {
    region         = "eu-central-1"
    bucket         = "terraform-aws-uweeisele-dev"
    key            = "benchmark-vpc"
    dynamodb_table = "terraform-aws-uweeisele-dev"
  }
}
