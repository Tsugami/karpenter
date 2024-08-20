# resource "kubernetes_namespace" "monitoring" {
#     metadata {
#       name = "monitoring"
#     }
# }

# resource "helm_release" "kube_prometheus_stack" {
#   name      = "kube-prometheus-stack"
#   namespace = "monitoring"

#   depends_on = [ kubernetes_namespace.monitoring ]

#   chart      = "kube-prometheus-stack"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   version    = "62.0.0"

#   set {
#     name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
#     value = "false"
#   }

#   set {
#     name  = "defaultRules.create"
#     value = "true"
#   }

#   set {
#     name  = "grafana.persistence.enabled"
#     value = "false"
#   }

#   set {
#     name  = "nodeExporter.enabled"
#     value = "false"
#   }

#   set {
#     name  = "grafana.adminPassword"
#     value = "admin"
#   }
# }
