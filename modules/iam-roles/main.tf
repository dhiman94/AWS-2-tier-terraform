resource "aws_iam_role" "ec2_codedeploy_role" {
  name = "ec2_codedeploy_role_terraform"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

resource "aws_iam_policy" "ec2_codedeploy_policy" {
  name        = "ec2_codedeploy_policy_terraform"
  description = "grants full permission to codedeploy, Get* and Put* on s3 artifacts bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetAccessPoint",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAccessPoints",
                "s3:ListJobs",
                "codedeploy:*",
                "s3:CreateJob"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:Put*"
            ],
            "Resource": "*" 
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.ec2_codedeploy_role.name}"
  policy_arn = "${aws_iam_policy.ec2_codedeploy_policy.arn}"
}

resource "aws_iam_instance_profile" "ec2_codedploy_profile" {
  name = "ec2_codedploy_profile"
  role = aws_iam_role.ec2_codedeploy_role.name
}

output "ec2_codedeploy_profile_name" {
    value = aws_iam_instance_profile.ec2_codedploy_profile.name
}

output "ec2_codedeploy_role_arn" {
  value = aws_iam_role.ec2_codedeploy_role.arn
}
# create codedeploy service role
resource "aws_iam_role" "codedeploy_service_role" {
  name = "codedeploy_service_role_terraform"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# codedeploy service role policy attachment
resource "aws_iam_role_policy_attachment" "codedeploy_service_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy_service_role.name
}

output "codedeploy_service_role_arn" {
  value = aws_iam_role.codedeploy_service_role.arn
}
