resource "random_pet" "this" {
  length = 3
}

resource "aws_s3_bucket" "my_test_bucket" {
  bucket = "${local.bucket_name}-${random_pet.this.id}"
  acl    = "public-read"
   website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "${local.bucket_name}-${random_pet.this.id}"
    Environment = local.env
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.my_test_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.my_test_bucket.arn,
      "${aws_s3_bucket.my_test_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket      = aws_s3_bucket.my_test_bucket.id
  key         = "index.html"
  source      = "index.html"
  source_hash = filemd5("index.html")
  acl         = "public-read"
}

resource "aws_s3_bucket_object" "error" {

  bucket      = aws_s3_bucket.my_test_bucket.id
  key         = "error.html"
  source      = "error.html"
  source_hash = filemd5("error.html")
  acl         = "public-read"
}