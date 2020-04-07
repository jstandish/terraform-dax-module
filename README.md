# Example for Terraform DynamoDB Accelerator (DAX) module
This is a demo module for creating a DAX cluster.



### Example usage

```terraform

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
```

## Resources Created
- DAX Cluster
- DAX Subnet Group
- Security Group
- IAM Role & Policy

