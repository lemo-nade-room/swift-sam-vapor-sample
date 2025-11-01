resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "gha_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}/${var.github_repository}:*"]
    }
  }
}

resource "aws_iam_role" "gha" {
  name               = "gha-${var.github_owner}-${var.github_repository}"
  assume_role_policy = data.aws_iam_policy_document.gha_assume_role.json
}

resource "aws_iam_role_policy_attachment" "cloud_formation" {
  role       = aws_iam_role.gha.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}
resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.gha.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}
resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.gha.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.gha.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.gha.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
resource "aws_iam_role_policy_attachment" "iam" {
  role       = aws_iam_role.gha.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}
resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.gha.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
