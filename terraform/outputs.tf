# getting values from ecr
output "ecr_repository_url" {
  description = "The URL of the created ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "ecr_repository_arn" {
  description = "The ARN of the created ECR repository"
  value       = aws_ecr_repository.app.arn
}

# geting values from vpc
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "web_security_group_id" {
  description = "The ID of the web security group"
  value       = aws_security_group.web_sg.id
}


# Getting values from ec2
output "jenkins_public_ip" {
  description = "Public IP of the Jenkins EC2 Server"
  value       = aws_instance.jenkins_server.public_ip
}

output "jenkins_url" {
  description = "URL to access Jenkins Web UI"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

# AWS EKS via Terraform
output "eks_cluster_name" {
  description = "The name of the EKS Cluster"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}