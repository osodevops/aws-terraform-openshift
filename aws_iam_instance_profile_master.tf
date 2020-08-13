resource "aws_iam_instance_profile" "master_node_profile" {
  name = "OCP-MASTER-NODE-PROFILE"
  role = aws_iam_role.master_node_role.name
}

resource "aws_iam_role" "master_node_role" {
  name               = "OCP-MASTER-NODE-IAM-ROLE"
  assume_role_policy = data.aws_iam_policy_document.master_node_assume_role.json
}

# IAM Policies
data "aws_iam_policy_document" "master_node_assume_role" {
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