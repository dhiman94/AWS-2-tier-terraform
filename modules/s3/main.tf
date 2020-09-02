# create one s3 bucket for storing artifacts
resource "aws_s3_bucket" "codedeploy_artifacts" {
  bucket = "dhiman-codedeploy-artifacts"
  acl    = "private"

  lifecycle_rule {
    id      = "delete_old_artifacts"
    enabled = true

    expiration {
        days = 30
    }

  }

  
  tags = {
    Name        = "Codedeploy Artifacts"
    Environment = "Dev"
  }
}

# create bucket policy to allow ec2 codedeploy role
resource "aws_s3_bucket_policy" "s3_codedeploy_policy" {
  bucket = aws_s3_bucket.codedeploy_artifacts.id

  policy = <<POLICY
{
     
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.ec2_codedeploy_role_arn}"
            },
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::dhiman-codedeploy-artifacts/*"
        }
    ]

   }
   POLICY
}
