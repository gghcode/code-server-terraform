data "archive_file" "sources" {
  type        = "zip"
  source_file = "../../src/ec2_scheduler.py"
  output_path = "ec2_scheduler.zip"
}

resource "aws_iam_role" "ec2_scheduler_role" {
  name = "ec2_scheduler_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }  
  ]
}
EOF
}

data "aws_iam_policy_document" "ec2_scheduler" {
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

resource "aws_iam_policy" "scheduler_aws_lambda_basic_execution_role" {
  policy = "${data.aws_iam_policy_document.ec2_scheduler.json}"
}

resource "aws_iam_role_policy_attachment" "basic-exec-role" {
  role       = "${aws_iam_role.ec2_scheduler_role.name}"
  policy_arn = "${aws_iam_policy.scheduler_aws_lambda_basic_execution_role.arn}"
}

resource "aws_lambda_function" "ec2_schedule_lambda" {
  function_name    = "ec2_schedule_lambda"
  role             = "${aws_iam_role.ec2_scheduler_role.arn}"
  filename         = "ec2_scheduler.zip"
  handler          = "ec2_scheduler.handler"
  runtime          = "python3.7"
  source_code_hash = "${data.archive_file.sources.output_base64sha256}"

  environment {
    variables = {
      INSTANCE_ID = "${aws_instance.my_workspace_ec2.id}"
    }
  }
}
