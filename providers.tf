# Provider do cluster EKS da fase 3 (ADR-026 / ADR-030 do repo postech-sw-arch-p3).
#
# Este repo provisiona SÓ o cluster Kubernetes e seus addons de base.
# O deploy da APLICAÇÃO (manifests k8s, overlay EKS) permanece no repo
# principal `postech-sw-arch-p3` — mesma separação cluster/cargas que a
# fase 2 usou no AKS: o plan das cargas não pode depender de um cluster
# criado no mesmo apply.
#
# Estado LOCAL de propósito (ADR-026): a vida útil do cluster é a janela
# de uma sessão do AWS Academy (~4h) ou o intervalo até o `terraform
# destroy` pós-demo. Um backend remoto (S3 + lock) sobreviveria ao state
# que deveria proteger — complexidade sem benefício aqui.
#
# Credenciais via profile "academy" (var.aws_profile): o runbook
# `aws-academy-setup.md` (repo postech-sw-arch-p3-docs) descreve como
# copiar o trio access key + secret + session token de cada Start Lab
# para o ~/.aws/credentials. As credenciais expiram com a sessão do lab.

terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Região fixa da fase 3 (ADR-026): o Learner Lab só libera us-east-1.
  region  = "us-east-1"
  profile = var.aws_profile

  default_tags {
    tags = {
      projeto    = "pytstop"
      fase       = "3"
      managed-by = "terraform"
    }
  }
}
