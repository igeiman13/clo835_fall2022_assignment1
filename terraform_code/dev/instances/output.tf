# Step 10 - Add output variables
output "eip" {
  value = aws_eip.static_eip.public_ip
}

output "ecr_repo_urls" {
  description = "URLs of the deployed ECR repositories"
  value = {
    webapp_repo_url = aws_ecr_repository.webapp_repo.repository_url,
    mysql_repo_url = aws_ecr_repository.mysql_repo.repository_url
  }
}
