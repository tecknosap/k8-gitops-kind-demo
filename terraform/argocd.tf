# Create the namespace where Argo CD will run
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Install Argo CD using the official Helm chart
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  # Official Argo Project Helm repository
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  # Use values instead of `set` for maximum provider compatibility
  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"   # Keep Argo CD internal (port-forward later)
        }
      }
    })
  ]

  # Ensure namespace exists before Helm install
  depends_on = [
    kubernetes_namespace.argocd
  ]
}