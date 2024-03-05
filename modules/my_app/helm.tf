terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "helm" {
  kubernetes {
#    config_path = var.kube_config_path
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "my_app" {
  metadata {
    name        = var.namespace
    annotations = { name = "my-app" }
    labels      = { namespace = var.namespace }
  }
}

#resource "helm_release" "pac-man" {
#  name    = "pac-man"
#  version = "0.0.1"
#  chart   = "./charts/pac-man"
#  namespace  = kubernetes_namespace.my_app.name
#  values = [
#    templatefile("${path.module}/resources/fluentbit_values.yaml", {
#      graylog_hostname = var.graylog_hostname
#    })
#  ]
#}

resource "helm_release" "my_app" {
  name      = "pacman"
  version   = "0.1.0"
  chart     = "./pacman"
  namespace = "my_app" #kubernetes_namespace.my_app.name
  #  values = [
  #    templatefile("./resources/mongo_values.yaml", {
  #      graylog_hostname = var.graylog_hostname
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