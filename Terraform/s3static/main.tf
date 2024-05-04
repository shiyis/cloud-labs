resource "aws_s3_bucket" "bucket" {
  bucket = "s3websitetest1235abcd245"
  acl    = "public-read"
  policy = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

}
