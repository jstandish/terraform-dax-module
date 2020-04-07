resource "aws_iam_service_linked_role" "dax" {
  aws_service_name = "dax.amazonaws.com"
}

resource "aws_iam_role_policy" "dax_access_policy" {
  name = "dax-access-policy"
  role = "${aws_iam_service_linked_role.dax.arn}"
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
            "dynamodb:DescribeTable",
            "dynamodb:PutItem",
            "dynamodb:GetItem",
            "dynamodb:UpdateItem",
            "dynamodb:DeleteItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:BatchGetItem",
            "dynamodb:BatchWriteItem",
            "dynamodb:ConditionCheckItem"
        ],
        "Effect": "Allow",
        "Resource": "${var.dynamodb_table}"
      }
    ]
  }
  EOF
}

resource "aws_dax_subnet_group" "subnets" {
  name       = "example"
  subnet_ids = "${var.subnet_ids}"
}

resource "aws_security_group" "allow_communication" {
  name        = "Allow DAX Communication"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = "${var.src_security_group_ids}"
    cidr_blocks = "${var.security_group_ingress_cidr_blocks}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.security_group_ingress_cidr_blocks}"
  }

  tags = "${var.tags}"
}
resource "aws_dax_cluster" "cluster" {
  cluster_name       = "${var.cluster_name}"
  iam_role_arn       = "${aws_iam_service_linked_role.dax.arn}"
  node_type          = "${var.node_type}"
  replication_factor = "${var.replication_factor}"
  subnet_group_name = "${aws_dax_subnet_group.subnets.id}"
  security_group_ids = ["${aws_security_group.allow_communication.id}"]
  tags  =   "${var.tags}"

  server_side_encryption { // always enable SSE
      enabled = true
  }
}