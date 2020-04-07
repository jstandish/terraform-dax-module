provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}

locals {
    tags = {
        Terraform = "true"
        Environment = "dev"
        Application = "dax-example"
    }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  tags = local.tags
}


resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "ExampleTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"
  range_key      = "Range"

  attribute {
    name = "Id"
    type = "S"
  }

  attribute {
    name = "Range"
    type = "S"
  }

  tags = local.tags
}

module "dax" {
    source = "./dynamodb-dax"
    cluster_name = "example-dax-cluster"
    dynamodb_table_arns = ["${aws_dynamodb_table.basic-dynamodb-table.arn}"]
    vpc_id = "${module.vpc.vpc_id}"
    subnet_ids = module.vpc.private_subnets
    security_group_ingress_cidr_blocks = module.vpc.private_subnets_cidr_blocks //allow any private cidr to talk to DAX
    // Example - You can restrict that only certain security groups can speak to DAX
    // src_security_group_ids = "${example_security_group_ids}"
    tags = local.tags
}