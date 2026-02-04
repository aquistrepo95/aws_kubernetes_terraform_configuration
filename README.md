# Terraform configuration for a single EC2 instance running all control plane components for Kubernetes

## Functional Terraform infrastructure project to run the control plane node for Kubernetes.

## This project showcases the following concepts in Terraform:
* Deploying AWS infrastructure using Terraform to provision components like: VPC, EC2, security groups, etc.
* Deploying Kubernetes control plane components to run on AWS infrastructure.

## Built with:
* Terraform
* AWS CLI
* Docker: Docker engine, Docker CRI(Container Runtime Interface).
* Kubernetes: Kubeadm, Kubectl, Kubelet.
* BASH: script to provide Kubernetes and control-plane specific components.

## This section will describe: how to deploy the infrastructure on AWS.
* Prequisite: Terraform is installed, and AWS CLI is installed and configured with keys.
* Generate private and public keys and copy them to ssh_keys and ssh_keys.pub.
  ```
  $ ssh-keygen -C "your_email@example.com" -f ssh_keys
  ```
* Run Terraform commands to deploy the infrastructure to AWS.
  ```
  $ terraform fmt
  $ terraform init
  $ terrafrom validate
  $ terraform apply
  ```
  NB: This may take a few minutes to complete.
* The master/control plane node is ready.
