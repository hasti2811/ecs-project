output "repo_img_uri" {
  value = data.aws_ecr_repository.my-ecr-repo.repository_url
}

output "image_uri_main" {
  value = "${data.aws_ecr_repository.my-ecr-repo.repository_url}:latest"
}
