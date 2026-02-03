variable "instance_tags" {
  description = "tags for the compute module"
  type        = map(string)  
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "instance_subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "vpc_id_instance" {
  description = "value for the VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "value for the VPC CIDR block" 
  type        = string
}