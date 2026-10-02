# 1. إعداد مزود الـ Kubernetes والـ Helm (إذا لم تكن أضفتهم في main.tf)
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}

# 2. إنشاء ConfigMap لحقن الـ Bastion IP
resource "kubernetes_config_map" "bastion_cm" {
  metadata {
    name = "bastion-ip-config"
  }

  data = {
    # تأكد أن هذا المتغير يطابق اسم الـ output الناتج عندك للـ Bastion IP (مثلاً module.compute.bastion_public_ip)
    BASTION_IP = module.compute.bastion_public_ip 
  }
}

# 3. نشر NGINX Pod وقراءة الـ ConfigMap
resource "kubernetes_pod" "nginx_app" {
  metadata {
    name = "nginx-bastion-reader"
  }

  spec {
    container {
      image = "nginx:latest"
      name  = "nginx"

      env {
        name = "AWS_BASTION_IP"
        value_from {
          config_map_key_ref {
            name = kubernetes_config_map.bastion_cm.metadata[0].name
            key  = "BASTION_IP"
          }
        }
      }
    }
  }
}

# 4. تثبيت Traefik Ingress Controller باستخدام Helm (هذا هو المقطع المطلوب)
resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = "default"
  create_namespace = true
}
