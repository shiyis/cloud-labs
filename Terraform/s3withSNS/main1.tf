resource "aws_sns_topic" "topic" {
  name = "topic-name"
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "sns"
  endpoint  = var.email
}

resource "aws_sns_topic" "my_first_sns_topic" {
  name = var.sns_name
}

resource "aws_sns_topic_policy" "my_sns_topic_policy" {
  arn = aws_sns_topic.my_first_sns_topic.arn
  policy = data.aws_iam_policy_document.my_custom_sns_policy_document.json
}

data "aws_iam_policy_document" "my_sns_policy_document" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.my_first_sns_topic.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "random_pet" "this" {
  length = 3
}

resource "aws_s3_bucket" "bucket" {
  bucket = "training-${random_pet.this.id}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}