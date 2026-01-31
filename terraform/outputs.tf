output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_url" {
  description = "URL to access the application"
  value       = "http://${aws_lb.main.dns_name}"
}

output "ecr_repository_url" {
  description = "ECR repository URL for pushing Docker images"
  value       = aws_ecr_repository.app.repository_url
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.mysql.db_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.app.name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for ECS logs"
  value       = aws_cloudwatch_log_group.ecs.name
}