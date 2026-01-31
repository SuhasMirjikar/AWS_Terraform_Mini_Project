variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "app_name" {
  description = "Application name"
  default     = "conversations"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

# ============================================
# DATABASE VARIABLES
# ============================================

variable "db_name" {
  description = "Database name"
  default     = "conversationsdb"
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS (GB)"
  default     = 20
}

# ============================================
# ECS VARIABLES
# ============================================

variable "ecs_task_cpu" {
  description = "ECS task CPU (256, 512, 1024, 2048, 4096)"
  default     = "256"
}

variable "ecs_task_memory" {
  description = "ECS task memory in MB (512, 1024, 2048, etc)"
  default     = "512"
}

variable "ecs_desired_count" {
  description = "Number of ECS tasks to run"
  default     = 2
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks for auto scaling"
  default     = 4
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  default     = 30
}