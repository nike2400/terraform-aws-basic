# ---------------------------------
#  S3
# ---------------------------------

# Unique key for s3 
resource "random_string" "s3_unique_key" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}


# s3 for Static files
resource "aws_s3_bucket" "s3_static_bucket" {
  bucket = "${var.project}-${var.environment}-static-bucket-${random_string.s3_unique_key.result}"
}

resource "aws_s3_bucket_versioning" "s3_static_bucket_versioning" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "s3_static_bucket_policy" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  policy = data.aws_iam_policy_document.s3_static_bucket_policy_doc.json

  # Due to the change in AWS settings, you mus set "depends_on" to make sure that access_block is created before bucket_policy
  # Some resources says that you must set depends_on the other way round but it doesn't work.
  depends_on = [aws_s3_bucket_public_access_block.s3_static_bucket_block]
}

# Public access block depends on bucket policy for static bucket
resource "aws_s3_bucket_public_access_block" "s3_static_bucket_block" {
  bucket                  = aws_s3_bucket.s3_static_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "s3_static_bucket_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_static_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloud_front_oai.iam_arn]
    }
  }
}

# s3 for deploy source storage
resource "aws_s3_bucket" "s3_deploy_bucket" {
  bucket = "${var.project}-${var.environment}-deploy-bucket-${random_string.s3_unique_key.result}"
}

resource "aws_s3_bucket_versioning" "s3_deploy_bucket_versioning" {
  bucket = aws_s3_bucket.s3_deploy_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "s3_deploy_bucket_policy" {
  bucket = aws_s3_bucket.s3_deploy_bucket.id
  policy = data.aws_iam_policy_document.s3_deploy_bucket_policy_doc.json
  # Due to the change in AWS settings, you mus set "depends_on" to make sure that access_block is created before bucket_policy
  # Some resources says that you must set depends_on the other way round but it doesn't work.
  depends_on = [aws_s3_bucket_public_access_block.s3_deploy_bucket_block]
}

resource "aws_s3_bucket_public_access_block" "s3_deploy_bucket_block" {
  bucket                  = aws_s3_bucket.s3_deploy_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "s3_deploy_bucket_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_deploy_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.app_iam_role.arn] # only App server allowed
    }
  }
}
