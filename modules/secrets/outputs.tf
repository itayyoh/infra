output "github_token_secret_arn" {
  description = "ARN of the GitHub token secret"
  value       = aws_secretsmanager_secret.github_token.arn
}