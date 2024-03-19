# Minikube Cluster
This repo lets you create a minikube environment in the AWS cloud provider using the Terraform IaC approach, you find also a sample application test that renders a API KEY configured in the environment variable.
## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (tested with 1.4.6)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with your credentials (tested with 2.7.7)

Refer to the [AWS IAM User Configuration](./IAM.md) for more information on how to configure your AWS credentials.


## Getting started

```bash
$ git clone https://github.com/HASHKS1/minikube-IaC.git
$ cd minikube-IaC
```


## Setting up infra
- [ ] Run the "tf_remote_backend" script for init config 
```bash
$ chmod +x tf_remote_backend.sh
$ ./tf_remote_backend.sh YOUR_AWS_REGION YOUR_BUCKET_NAME YOUR_DYNAMODBTABLE_NAME
```

### Create a new Terraform backend configuration file

```bash
$ cat > backend.tf <<EOF
###
### Backend
###
terraform {
  backend "s3" {
    bucket         = "YOUR_BUCKET_NAME"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "YOUR_AWS_REGION"
    dynamodb_table = "YOUR_DYNAMODB_TABLE_NAME"
  }
}
EOF
```

## Usage
- [ ] Initialize Terraform
```bash
$ terraform init -backend-config=backend.tf
```

- [ ] Create Infrastructure
```bash
$ terraform apply --auto-approve
```

- [ ] Done! You now have a fully functional Kubernetes cluster with 1 master and 1 worker.

***
## Stages
- [ ] Setup AWS IAM user Account "Deployment-IaC" with AdministratorAccess
- [ ] Terraform apply will manage the underlying infrastructure for minikube installation E2E
- [ ] The key used to launch this instance is minikube-dev-pki.pem in the PKI folder
- [ ] Build the application using docker build cmd
- [ ] Deploy the application using kubectl cli cmd
## Tools

- [ ] Terraform
- [ ] Bash script for minikube automation 
- [ ] Node js app
- [ ] Docker packaging the application
- [ ] K8s manifest
## Take Notice
- [ ] Minikube boosting takes time after the EC2 instance is up and running.