
resource "aws_iam_role" "ssm_role" {
  name               = "ssm_role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Effect": "Allow",
    "Principal": {
        "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
    }
]

}
EOF
}
resource "aws_iam_policy_attachment" "ssm_iam_policy_attach" {
  name       = "attach_ssm_policy"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

output "ssm_instance_profile" {
  value = aws_iam_instance_profile.ssm_instance_profile.name
  
}