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

* Initial installation will not enable kubectl. To fix this, ssh to the AWS instance and run the following commands in the CLI.
* Initial installation will not add kubectl config files:
  ```
  ubuntu@ip-10-0-1-95:~$ kubectl get nodes
  E0203 17:26:51.192180    7009 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp                127.0.0.1:8080: connect: connection refused"
  E0203 17:26:51.192978    7009 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp
  127.0.0.1:8080: connect: connection refused"
  E0203 17:26:51.194093    7009 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp
  127.0.0.1:8080: connect: connection refused"
  E0203 17:26:51.194423    7009 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp
  127.0.0.1:8080: connect: connection refused"
  E0203 17:26:51.195779    7009 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp
  127.0.0.1:8080: connect: connection refused"
  The connection to the server localhost:8080 was refused - did you specify the right host or port?
  ```
* ssh to the AWS instance from your local workstation:
  ```
  $ ssh ubuntu@$(terraform output -raw instance_public_ip) -i ssh_keys -v
  ```
  NB: $(terraform output -raw instance_public_ip) is the public IP address of the AWS instance. This address can be copied from the Amazon EC2 console.
* Add Kubectl config files:
  ```
  $ mkdir -p $HOME/.kube
  $ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  $ sudo chown $(id -u):$(id -g) $HOME/.kube/config
  ```  
* The master/control plane node is ready.
