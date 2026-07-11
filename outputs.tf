output "cluster_name" {
  description = "Nome do cluster EKS (consumido pelo pipeline de deploy do repo principal)."
  value       = aws_eks_cluster.pytstop.name
}

output "cluster_endpoint" {
  description = "Endpoint público da API do Kubernetes."
  value       = aws_eks_cluster.pytstop.endpoint
}

output "cluster_security_group_id" {
  description = "Security group do cluster (nodes incluídos). Consumido pelo repo p3-infra-db via var `extra_security_group_ids` para liberar o 5432 aos nodes."
  value       = aws_eks_cluster.pytstop.vpc_config[0].cluster_security_group_id
}

output "update_kubeconfig_command" {
  description = "Comando que funde o kubeconfig do cluster no ~/.kube/config (usado pelo make kubeconfig)."
  value = format(
    "aws eks update-kubeconfig --name %s --profile %s --region us-east-1",
    aws_eks_cluster.pytstop.name,
    var.aws_profile,
  )
}

# Nenhum kubeconfig/certificado é exposto como output (iria para o
# tfstate/logs): o `aws eks update-kubeconfig` busca as credenciais sob
# demanda via API — mesmo racional do AKS na fase 2.
