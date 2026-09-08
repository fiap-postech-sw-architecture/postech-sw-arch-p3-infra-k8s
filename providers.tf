# Provider do cluster EKS da fase 3 (ADR-026 / ADR-030 do repo postech-sw-arch-p3).
#
# Este repo provisiona SÓ o cluster Kubernetes e seus addons de base.
# O deploy da APLICAÇÃO (manifests k8s, overlay EKS) permanece no repo
# principal `postech-sw-arch-p3` — mesma separação cluster/cargas que a
# fase 2 usou no AKS: o plan das cargas não pode depender de um cluster
# criado no mesmo apply.
#
# Credenciais do Learner Lab via cadeia padrao, sempre em us-east-1.

terraform {
  required_version = ">= 1.10"

  backend "s3" {
    bucket       = "pytstop-terraform-state-924563550535"
    key          = "eks/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Região fixa da fase 3 (ADR-026): o Learner Lab só libera us-east-1.
  region = "us-east-1"

  default_tags {
    tags = {
      projeto    = "pytstop"
      fase       = "3"
      managed-by = "terraform"
    }
  }
}
