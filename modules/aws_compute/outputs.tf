output "instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_instance.kube_server.id
}

/*output "ami_id" {
  description = "AMI ID used for the EC2 instance"
  value       = data.aws_ami.ubuntu.id
}*/

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.kube_server.public_ip
}