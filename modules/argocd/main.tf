# modules/argocd/main.tf

# Create namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Install ArgoCD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.7"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    <<-EOT
    server:
      extraArgs:
        - --insecure
      service:
        type: LoadBalancer
      ingress:
        enabled: true
        ingressClassName: nginx
        hosts:
          - argocd.local
    
    configs:
      cm:
        url: https://argocd.local
        exec.enabled: "true"
        timeout.reconciliation: 180s
    
    repoServer:
      resources:
        limits:
          cpu: 100m
          memory: 128Mi
        requests:
          cpu: 50m
          memory: 64Mi
    
    controller:
      resources:
        limits:
          cpu: 500m
          memory: 512Mi
        requests:
          cpu: 250m
          memory: 256Mi

    # Enable custom resource installation
    crds:
      install: true
      keep: true
    EOT
  ]
}

# Wait for ArgoCD to be ready
resource "time_sleep" "wait_for_argocd" {
  depends_on = [helm_release.argocd]
  create_duration = "30s"
}

# Install URL Shortener project and application configurations
resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  chart      = "${path.module}/helm"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  depends_on = [time_sleep.wait_for_argocd]
}