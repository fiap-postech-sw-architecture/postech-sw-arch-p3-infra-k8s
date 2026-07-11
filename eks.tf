# Cluster EKS mínimo da fase 3 (ADR-030): node group gerenciado
# 2× t3.medium — o menor tamanho que roda o stack (app + Redis + relay +
# observabilidade) com folga para o HPA escalar. Sem node group extra,
# sem Fargate profile.
#
# IAM: restrição dura do AWS Academy (ADR-026) — o Terraform NÃO cria
# roles/policies. Cluster role e node role apontam para a LabRole
# pré-existente, referenciada por data source. Numa conta de produção
# seriam roles mínimas separadas; aqui é uma concessão documentada.

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Rede: VPC default da conta. O Learner Lab já a entrega com subnets
# públicas e internet gateway — criar VPC própria só queimaria budget
# (NAT) sem ganho para uma demo efêmera.
data "aws_vpc" "default" {
  default = true
}

# O control plane do EKS não aceita us-east-1e (capacidade insuficiente
# da AZ); filtramos para as AZs suportadas para o create não falhar.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}

resource "aws_eks_cluster" "pytstop" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = data.aws_iam_role.lab_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids
    # Endpoint público: o kubectl da máquina do dev e o pipeline do repo
    # principal acessam o cluster de fora da VPC. Endpoint privado +
    # bastion seria o desenho de produção; desnecessário numa demo.
    endpoint_public_access  = true
    endpoint_private_access = false
  }
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.pytstop.name
  node_group_name = "${var.cluster_name}-nodes"
  node_role_arn   = data.aws_iam_role.lab_role.arn
  subnet_ids      = data.aws_subnets.default.ids

  instance_types = ["t3.medium"]
  disk_size      = 20

  # 2 nodes fixos (ADR-030) + 1 de folga para o cluster autoscaling não
  # travar rolling updates do node group. O HPA escala pods; a
  # elasticidade de capacidade fica demonstrada pelo max > desired.
  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }
}
