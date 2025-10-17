output "user_arn" {
  value = aws_iam_user.example_user.arn
}

output "group_name" {
  value = aws_iam_group.developers.name
}
