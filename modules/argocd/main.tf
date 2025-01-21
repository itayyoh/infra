# modules/argocd/main.tf

# Add namespace first
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Create GitHub token secret
# Update the kubernetes_secret in modules/argocd/main.tf

resource "kubernetes_secret" "github_token" {
  metadata {
    name      = "github-token-itay"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  data = {
    username = "gitops"  # This can be any string
    token    = var.github_token
  }
}
# Install ArgoCD using Helm
# modules/argocd/main.tf

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
        repositories: |
          # Your existing gitops repo config
          - url: ${var.gitops_repo_url}
            type: git
            name: gitops-repo
            usernameSecret:
              name: github-token-itay
              key: username
            passwordSecret:
              name: github-token-itay
              key: token
          # Add Helm repositories
          - type: helm
            url: https://charts.bitnami.com/bitnami
            name: bitnami
          - type: helm
            url: https://kubernetes.github.io/ingress-nginx
            name: ingress-nginx
    
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

    crds:
      install: true
      keep: true
    EOT
  ]


  depends_on = [kubernetes_secret.github_token]
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
  force_update = true  # Add this line to force update

  set {
    name  = "gitops.repoUrl"
    value = var.gitops_repo_url
  }

  set {
    name  = "gitops.targetRevision"
    value = var.gitops_repo_branch
  }

  set {
    name  = "gitops.path"
    value = "apps"
  }
}