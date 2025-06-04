data "aws_iam_policy_document" "cloudwatch_agent_policy" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name   = "CloudWatchAgentPolicy"
  policy = data.aws_iam_policy_document.cloudwatch_agent_policy.json
}

resource "aws_iam_role" "ec2_instance_role" {
  name = "EC2InstanceCloudWatchRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}
