terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# S3 Bucket erstellen
resource "aws_s3_bucket" "website_bucket" {
  bucket = "vue-frontend-application-m324" 

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "FrontendWebsite"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.website_bucket.arn}/*"]
      }
    ]
  })
}

output "website_endpoint" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}
