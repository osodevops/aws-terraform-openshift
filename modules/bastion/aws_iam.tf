resource "aws_iam_instance_profile" "bastion_profile" {
  name = "OCP-BASTION-PROFILE"
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