variable "cluster_name" {
  description = "Nome do cluster EKS. Também referenciado pelo overlay EKS e pelo pipeline do repo principal."
  type        = string
  default     = "pytstop-p3"
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes do EKS. Pin explícito (diferente do AKS da fase 2) porque o EKS cobra suporte estendido de versões antigas — 1.31 já está em extended support (~6× o custo do control plane). Conferir a versão mais recente em suporte padrão quando a conta Academy for ativada."
  type        = string
  default     = "1.34"
}
