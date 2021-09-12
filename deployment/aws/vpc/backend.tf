terraform {
  backend "s3" {
    bucket  = "terraform-aws-uweeisele-dev"
    key     = "benchmark-vpc"
    region  = "eu-central-1"
  }
}
