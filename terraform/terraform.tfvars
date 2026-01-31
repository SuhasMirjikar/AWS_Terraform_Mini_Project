# Terraform Variables Configuration - DEVELOPMENT/COST-OPTIMIZED
# This configuration is optimized for learning and testing with minimal costs
# Estimated monthly cost: $50-70

aws_region = "ap-south-1"
app_name   = "conversations"

# ============================================
# DATABASE CONFIGURATION - COST OPTIMIZED
# ============================================
# Using db.t3.micro (eligible for AWS free tier in first 12 months)
# Saves ~$15-20/month compared to db.t3.small

db_username           = "admin"
db_password           = "ConversationsApp2024!"  # CHANGE THIS to a strong password
db_name               = "awsterraformconversations"
db_instance_class     = "db.t3.micro"     # FREE TIER ELIGIBLE (first 12 months)
db_allocated_storage  = 20                # GB - FREE for first 12 months

# ============================================
# ECS CONFIGURATION - COST OPTIMIZED
# ============================================
# Running only 1 task instead of 2
# Saves ~$12-17/month on compute costs
# Auto-scaling still available if load increases

ecs_task_cpu         = "256"    # Minimum CPU units (lowest cost)
ecs_task_memory      = "512"    # Minimum memory (512 MB)
ecs_desired_count    = 1        # REDUCED: Run only 1 task (saves ~$12-17/month)
ecs_max_capacity     = 2        # Still scale to 2 if needed

log_retention_days   = 7        # REDUCED: Keep logs for only 7 days (saves ~$5/month)

# ============================================
# COST ESTIMATES
# ============================================
# NAT Gateway:              ~$32/month
# RDS (db.t3.micro):        FREE first 12 months (then ~$20/month)
# ECS Fargate (1 task):     ~$12-17/month (reduced from ~$25-35)
# Application Load Balancer: ~$16/month
# CloudWatch Logs (7 days):  ~$2-5/month (reduced from ~$5-10)
# ECR & Data Transfer:      ~$5/month
# ─────────────────────────────────────────
# TOTAL:                    ~$67-70/month (non-free tier)
#                           ~$35-40/month (during 12-month free tier period)
