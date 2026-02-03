output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = module.ec2_instances.instance_ids
}

output "vpc_arn" {
  description = "The ARN of the created VPC"
  value       = module.vpc.vpc_arn
}

/*output "ami_id" {
  description = "AMI ID used for the EC2 instance"
  value       = module.ec2_instances.ami_id

}*/

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instances.instance_public_ip
}

output "vpc_id" {
  description = "value for the VPC ID"
  value       = module.vpc.vpc_id
}