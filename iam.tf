resource "null_resource" "delete_existing_role" {
  provisioner "local-exec" {
    command = "aws iam delete-role --role-name ${var.project_name}-rds-access-role || true"
  }
}

resource "aws_iam_role" "rds_access_role" {
  depends_on = [null_resource.delete_existing_role]
  name = "${var.project_name}-rds-access-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "null_resource" "delete_existing_policy" {
  provisioner "local-exec" {
    command = "aws iam delete-policy --policy-arn arn:aws:iam::$(aws sts get-caller-identity --query 'Account' --output text):policy/${var.project_name}-rds-read-write-policy || true"
  }
}

resource "aws_iam_policy" "rds_read_write_policy" {
  depends_on = [null_resource.delete_existing_policy]
  name        = "${var.project_name}-rds-read-write-policy"
  description = "Allow read and write to RDS"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBInstances",
        "rds:ListTagsForResource"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "rds-db:connect"
      ],
      "Resource": "arn:aws:rds-db:${var.aws_region}:*:dbuser/${var.db_username}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_rds_policy" {
  role       = aws_iam_role.rds_access_role.name
  policy_arn = aws_iam_policy.rds_read_write_policy.arn
}
