resource "aws_secretsmanager_secret" "github_token" {
  name        = "${var.environment}/github/token-itay"  # Changed name
  description = "GitHub Token for ArgoCD"

  tags = merge(var.tags, {
    Name = "${var.environment}-github-token-itay"
  })
}

resource "aws_secretsmanager_secret_version" "github_token" {
  secret_id     = aws_secretsmanager_secret.github_token.id
  secret_string = var.github_token
}