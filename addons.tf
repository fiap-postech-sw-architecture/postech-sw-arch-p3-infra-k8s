# Addons de base do cluster (gerenciados pelo EKS, não pelo kubectl).
#
# Versões NÃO pinadas de propósito: sem addon_version o EKS instala a
# versão default compatível com var.kubernetes_version — um pin aqui
# quebraria o apply quando a versão saísse de suporte, o mesmo motivo do
# kubernetes_version solto no AKS da fase 2.

# CNI e kube-proxy podem subir junto com o control plane (rodam como
# DaemonSet e toleram nodes ausentes).
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.pytstop.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.pytstop.name
  addon_name   = "kube-proxy"
}

# CoreDNS precisa de nodes prontos para agendar os pods — sem o
# depends_on o apply fica preso em DEGRADED até o node group existir.
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.pytstop.name
  addon_name   = "coredns"

  depends_on = [aws_eks_node_group.default]
}

# metrics-server: obrigatório para o HPA do repo principal (k8s/hpa.yaml
# — consequência registrada no ADR-030). O EKS não o instala por padrão,
# mas o oferece como COMMUNITY ADDON desde nov/2024 (nome
# "metrics-server"), então provisionamos aqui como os demais.
#
# Fallback se o plan/apply reclamar do addon indisponível na versão do
# cluster: comente este resource e aplique via kubectl no repo principal
# (kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/
# releases/latest/download/components.yaml), como o kind da fase 2 fazia.
resource "aws_eks_addon" "metrics_server" {
  cluster_name = aws_eks_cluster.pytstop.name
  addon_name   = "metrics-server"

  depends_on = [aws_eks_node_group.default]
}
