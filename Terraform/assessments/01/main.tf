resource "aws_sns_topic" "topic" {
  name = "s3-event-notification-topic"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.recovery_bucket.arn}"}
        }
    }]
}
POLICY
}

resource "random_pet" "this" {
  length = 3
}

resource "aws_s3_bucket" "recovery_bucket" {
  bucket = "data-recovery-bucket-${random_pet.this.id}"
  acl    = "private"

  versioning {
    enabled = true
  }

}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.recovery_bucket.id

  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}