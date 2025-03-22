resource "aws_iam_role" "rds_access_role" {
  name = "fastfood-rds-access-role"

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

resource "aws_iam_policy" "rds_read_write_policy" {
  name        = "fastfood-rds-read-write-policy"
  description = "Permite leitura e escrita no banco RDS"

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
