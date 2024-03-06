resource "kubernetes_namespace" "my_app" {
  metadata {
    name        = var.namespace
    annotations = { name = var.namespace }
    labels      = { namespace = var.namespace }
  }
}

resource "helm_release" "my_app" {
  name      = "pacman"
  version   = "0.1.0"
  chart     = "./pacman/"
  namespace = "my-app" #kubernetes_namespace.my_app.name
  #  values = [
  #    templatefile("./charts/mpy_app_values.yaml", {
  #      namrspace = var.namespace
  #    })
  #  ]
}

