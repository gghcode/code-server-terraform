data "archive_file" "sources" {
  type        = "zip"
  source_file = "${var.path_ec2_scheduler_py}"
  output_path = "${var.name_source_code_zip}"
}

data "terraform_remote_state" "api_gateway" {
  backend = "remote"
  config = {
    organization = "gghcode-server"

    workspaces = {
      name = "api-gateway"
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:StopInstances",
      "ec2:StartInstances",
      "ec2:CreateTags",
    ]

    resources = [
      "*",
    ]
  }
}
