# Deployment Guide for ECS Fargate with RDS

## Prerequisites

1. **AWS Account** with appropriate credentials
2. **Terraform** installed (v1.0+)
3. **AWS CLI** configured with credentials:
   ```bash
   aws configure
   ```
4. **Docker** installed (to build and push images)
5. Spring Boot application built as JAR

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                    Internet                     │
└──────────────────────┬──────────────────────────┘
                       │
        ┌──────────────▼──────────────┐
        │  Application Load Balancer  │
        │      (Public - Port 80)     │
        └──────────────┬──────────────┘
                       │
        ┌──────────────▼──────────────┐
        │   ECS Fargate Service       │
        │  (1-2 tasks running)        │
        │   Private Subnets           │
        │   Port 8080                 │
        └──────────────┬──────────────┘
                       │
        ┌──────────────▼──────────────┐
        │  RDS MySQL Database         │
        │  Private Subnet             │
        │  Multi-AZ for HA            │
        └─────────────────────────────┘
```

## Step-by-Step Deployment

### 1. Build the Spring Boot Application

```bash
cd conversations
mvn clean package -DskipTests
cd ..
```

### 2. Create Docker Image and Push to ECR

```bash
# Login to AWS ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

# Build the Docker image
docker build -f terraform/Dockerfile -t conversations:latest .

# Tag the image for ECR
docker tag conversations:latest <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/conversations:latest

# Push to ECR
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/conversations:latest
```

**Note:** Replace `<ACCOUNT_ID>` with your AWS Account ID

### 3. Configure Terraform Variables

Edit `terraform/terraform.tfvars`:

```hcl
aws_region = "us-east-1"
db_password = "YourSecurePassword123!@#"  # IMPORTANT: Change this!
ecs_desired_count = 2
ecs_max_capacity = 4
```

### 4. Initialize Terraform

```bash
cd terraform
terraform init
```

### 5. Review the Plan

```bash
terraform plan
```

Review the output to ensure all resources will be created as expected.

### 6. Apply the Terraform Configuration

```bash
terraform apply
```

When prompted, type `yes` to proceed.

**Wait:** This will take 10-15 minutes as it:
- Creates VPC, subnets, and networking
- Sets up RDS database
- Creates ECS cluster and service
- Configures load balancer

### 7. Get the Application URL

```bash
terraform output alb_url
```

Visit this URL in your browser to access your application.

## Testing the Application

After deployment is complete:

### Test the GET endpoint:
```bash
curl http://<ALB_DNS>/conversations
```

### Test the POST endpoint with Postman:
```
POST http://<ALB_DNS>/conversations
Content-Type: application/json

{
  "title": "Test Conversation",
  "content": "This is a test from AWS"
}
```

## Managing Your Deployment

### View Logs
```bash
# Get logs from CloudWatch
aws logs tail /ecs/conversations --follow
```

### Update the Application

1. Build and push new Docker image:
```bash
docker build -f terraform/Dockerfile -t conversations:latest .
docker tag conversations:latest <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/conversations:latest
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/conversations:latest
```

2. Update ECS service to use new image:
```bash
aws ecs update-service \
  --cluster conversations-cluster \
  --service conversations-service \
  --force-new-deployment \
  --region us-east-1
```

### Scale the Application

Edit `terraform/terraform.tfvars` and change:
```hcl
ecs_desired_count = 3  # Change the number of tasks
```

Then run:
```bash
terraform apply
```

### Monitor Performance

View CloudWatch metrics:
```bash
aws cloudwatch list-metrics --namespace AWS/ECS
```

## Cost Optimization

### Development Setup
```hcl
ecs_task_cpu     = "256"
ecs_task_memory  = "512"
ecs_desired_count = 1
db_instance_class = "db.t3.micro"
```

### Production Setup
```hcl
ecs_task_cpu     = "1024"
ecs_task_memory  = "2048"
ecs_desired_count = 3
db_instance_class = "db.t3.small"
```

## Cleanup (Delete Everything)

**WARNING:** This will delete all resources including the database.

```bash
terraform destroy
```

Type `yes` when prompted.

## Common Issues

### Issue: ECR Repository Not Found
**Solution:** Make sure the image is pushed to ECR before deploying:
```bash
aws ecr describe-repositories --repository-names conversations
```

### Issue: Tasks Keep Restarting
**Solution:** Check the logs:
```bash
aws logs tail /ecs/conversations --follow
```

### Issue: Database Connection Failed
**Solution:** Verify the security group allows access:
```bash
aws ec2 describe-security-groups --filters Name=tag:Name,Values=conversations-rds-sg
```

## Environment Variables

The following environment variables are automatically configured by Terraform:

```
SPRING_DATASOURCE_URL=jdbc:mysql://rds-endpoint:3306/conversationsdb
SPRING_DATASOURCE_USERNAME=admin
SPRING_DATASOURCE_PASSWORD=<your-password>
SPRING_JPA_HIBERNATE_DDL_AUTO=update
```

## Security Best Practices

1. **Change Default Password:** Update `db_password` in terraform.tfvars
2. **Use Secrets Manager:** Store sensitive data in AWS Secrets Manager
3. **Enable HTTPS:** Add an SSL certificate to the load balancer
4. **Restrict Access:** Update security groups to limit inbound traffic
5. **Backup Database:** Enable automated backups (configured by default)
6. **IAM Permissions:** Use least privilege IAM roles

## Useful Commands

```bash
# Get application URL
terraform output alb_url

# Get ECR repository URL
terraform output ecr_repository_url

# Get RDS endpoint
terraform output rds_endpoint

# List all outputs
terraform output

# Destroy all resources
terraform destroy

# Validate Terraform configuration
terraform validate

# Format Terraform files
terraform fmt -recursive
```

## Next Steps

1. Add HTTPS/SSL certificate to ALB
2. Set up custom domain with Route 53
3. Configure CI/CD pipeline for automated deployments
4. Set up monitoring and alerting
5. Implement auto-scaling policies
