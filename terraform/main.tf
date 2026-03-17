# Intentionally misconfigured Terraform for Trivy IaC scanning demo

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# S3 bucket with no encryption, public access, no versioning
resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-insecure-data-bucket"
  acl    = "public-read-write"  # Trivy: bucket publicly writable

  tags = {
    Environment = "production"
  }
}

# Missing: aws_s3_bucket_server_side_encryption_configuration
# Missing: aws_s3_bucket_versioning
# Missing: aws_s3_bucket_public_access_block

# Security group wide open
resource "aws_security_group" "open_sg" {
  name        = "open-everything"
  description = "Wide open security group"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Trivy: unrestricted ingress
    description = ""
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Trivy: unrestricted egress
  }
}

# RDS instance with no encryption, publicly accessible, no backups
resource "aws_db_instance" "insecure_db" {
  identifier           = "insecure-db"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "mydb"
  username             = "admin"
  password             = "password123"       # Trivy: hardcoded password
  publicly_accessible  = true                # Trivy: publicly accessible
  skip_final_snapshot  = true
  storage_encrypted    = false               # Trivy: not encrypted
  backup_retention_period = 0               # Trivy: no backups
  deletion_protection  = false
  multi_az             = false

  vpc_security_group_ids = [aws_security_group.open_sg.id]
}

# IAM role with wildcard permissions
resource "aws_iam_policy" "overly_permissive" {
  name = "overly-permissive-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["*"]           # Trivy: wildcard actions
        Resource = ["*"]           # Trivy: wildcard resources
      }
    ]
  })
}

# EC2 instance with public IP, no IMDSv2
resource "aws_instance" "insecure_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  associate_public_ip_address = true   # Trivy: public IP
  vpc_security_group_ids      = [aws_security_group.open_sg.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"  # Trivy: IMDSv2 not required
  }

  # No EBS encryption
  root_block_device {
    encrypted = false  # Trivy: unencrypted root volume
  }

  tags = {
    Name = "insecure-instance"
  }
}

# CloudTrail disabled
resource "aws_cloudtrail" "no_logging" {
  name                          = "minimal-trail"
  s3_bucket_name                = aws_s3_bucket.data_bucket.id
  include_global_service_events = false  # Trivy: global events not logged
  enable_log_file_validation    = false  # Trivy: log validation disabled
  is_multi_region_trail         = false  # Trivy: not multi-region
}
