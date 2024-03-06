# Terraform Demo EKS cluster.

## TL;DR;

```
1) cd into $ cd modules/s3backend
2) Run terraform init and terraform apply
3) go back to root module by running cd ../../
4) Run terraform init and terraform apply
5) Run terraform output to get URL for test EKS web app
```

## Introduction

This is terraform project that creates follwoing infrastructure in AWS:
- VPC, subnets, Nat Gateway and Internet Gateway
- EKS cluster and 1 node group
- Deploys helm web application to EKS