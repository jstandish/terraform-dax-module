resource "aws_iam_role" "dax_service_access_role" {
  name = "dax_service_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dax.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = "${var.tags}"
}

resource "aws_iam_role_policy" "dax_access_policy" {
  name = "dax-access-policy"
  role = "${aws_iam_role.dax_service_access_role.name}"
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
        "Resource": ["${join(", ", var.dynamodb_table_arns)}"]
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
  description = "Allow DAX inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description = "TLS from VPC"
    from_port   = 881
    to_port     = 881
    protocol    = "tcp"
    security_groups = "${var.src_security_group_ids}"
    cidr_blocks = var.security_group_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.security_group_egress_cidr_blocks
  }

  tags = "${var.tags}"
}
resource "aws_dax_cluster" "cluster" {
  cluster_name       = "${var.cluster_name}"
  iam_role_arn       = "${aws_iam_role.dax_service_access_role.arn}"
  node_type          = "${var.node_type}"
  replication_factor = "${var.replication_factor}"
  subnet_group_name = "${aws_dax_subnet_group.subnets.id}"
  security_group_ids = ["${aws_security_group.allow_communication.id}"]
  tags  =   "${var.tags}"

  server_side_encryption { // always enable SSE
      enabled = true
  }
}