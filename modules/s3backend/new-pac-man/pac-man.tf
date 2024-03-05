terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "my-app" {
  metadata {
    annotations = {
      name = "my-app"
    }

    labels = {
      namespace = "my-app"
    }

    name = "my-app"
  }
}

resource "helm_release" "mongodb" {
  name    = "mongodb"
  version = "0.0.1"
  chart   = "./charts/mongodb"
  #namespace  = kubernetes_namespace.name
  #  values = [
  #    templatefile("${path.module}/resources/external_dns.yaml.tpl", {
  #      cluster_name         = var.cluster_name
  #      service_account_name = var.service_account_name
  #      role_arn             = module.oidc_iam_role.arn
  #      region               = var.aws_region
  #    })
  #  ]
}

resource "helm_release" "pac-man" {
  name    = "pac-man"
  version = "0.0.1"
  chart   = "./charts/pac-man"
  #namespace  = kubernetes_namespace.name
  #  values = [
  #    templatefile("${path.module}/resources/external_dns.yaml.tpl", {
  #      cluster_name         = var.cluster_name
  #      service_account_name = var.service_account_name
  #      role_arn             = module.oidc_iam_role.arn
  #      region               = var.aws_region
  #    })
  #  ]
}

#module "mongo" {
#  source               = "./modules/mongo"
#  kubernetes_namespace = "my-app"
#}
#
#module "pac-man" {
#  source               = "./modules/pac-man"
#  kubernetes_namespace = "my-app"
#  depends_on           = [module.mongo]
#}