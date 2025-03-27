output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "db_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = module.vpc.db_subnet_group_name
}

output "db_instance_endpoint" {
  description = "The connection endpoint of the RDS instance"
  value       = module.rds.db_instance_endpoint
}

output "db_secret_arn" {
  description = "ARN of the secret containing database credentials"
  value       = module.rds.db_secret_arn
}
