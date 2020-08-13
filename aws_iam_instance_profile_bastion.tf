resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.environment}-OCP-BASTION-PROFILE"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_role" "bastion_role" {
  name               = "OCP-BASTION-IAM-ROLE"
  assume_role_policy = data.aws_iam_policy_document.bastion_assume_role.json
}

# IAM Policies
data "aws_iam_policy_document" "bastion_assume_role" {
  statement {
    principals {
      identifiers = [
        "ec2.amazonaws.com",
        "ssm.amazonaws.com",
      ]

      type = "Service"
    }

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "bastion_policy_document" {
  statement {
    actions = [
      "ec2:DescribeAddresses",
      "ec2:AssociateAddress",
      "ec2:AllocateAddress",
      "kms:CreateGrant"
    ]

    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:HeadBucket",
      "s3:ListObjects",
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${module.ansible_resource_bucket.s3_id}/*",
      "arn:aws:s3:::${module.keys_bucket.s3_id}/*"
    ]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "bastion_policy" {
  name        = "OCP-BASTION-S3-RESOURCES"
  description = "Allows the Bastion server to download resources from S3"
  policy      = data.aws_iam_policy_document.bastion_policy_document.json
}

resource "aws_iam_role_policy_attachment" "bastion_attach" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.bastion_policy.arn
}