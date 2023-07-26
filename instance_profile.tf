resource "aws_iam_instance_profile" "ssm-role-profile1" {
  name = "ssm_role_profile1"
  role = "SSM_ACCESS"
}