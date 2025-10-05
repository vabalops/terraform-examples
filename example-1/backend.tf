terraform {
  backend "s3" {
    bucket       = "terraform-state-f5f13793bb6520dc"
    key          = "example-1/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
  }
}
