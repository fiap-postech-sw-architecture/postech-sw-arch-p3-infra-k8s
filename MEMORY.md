# Project Memory -- postech-sw-arch-p3-infra-k8s

<!-- last-consolidated: 2026-07-11 -->

Add-only log of project-specific learnings. New entries go to the top of each section. Never edit historical entries -- add a contradicting entry above instead.

Updated by AI agents at task end per `postech-ai-helper/ai/canonical/task-end-review.md`. The `last-consolidated` marker above is updated only when `/consolidate-memory` runs, not on every append.

## Recent decisions
- 2026-09-07 - A VPC default recebe duas subnets privadas exclusivas da integracao Gateway-EKS: `172.31.240.0/24` em us-east-1a e `172.31.241.0/24` em us-east-1b, uma route table sem rota default, sem IP publico e sem NAT; tags `internal-elb` e do cluster permitem ao NLB interno e ao VPC Link descobri-las
- 2026-09-06 - State remoto substitui a decisao inicial de state local: backend S3 `pytstop-terraform-state-924563550535` na chave `eks/terraform.tfstate`, versionamento no bucket e lock nativo (`use_lockfile`, Terraform >=1.10); execucao local e Actions compartilham o mesmo state sem DynamoDB
- 2026-07-11 - Bootstrap fase 3: repo dedicado de infra K8s (EKS via Terraform, LabRole por data source, state local, região us-east-1) - decisões nos ADR-026/ADR-030 do repo postech-sw-arch-p3

## Discovered conventions

## Gotchas

- 2026-09-07 - Filtrar subnets do EKS apenas por VPC/AZ passa a incluir as subnets privadas criadas no mesmo apply no refresh seguinte; `data.aws_subnets.default` exige `default-for-az=true` para manter cluster e node group nas subnets publicas originais com egress
- 2026-09-06 - Learner Lab nega `iam:GetRole`; usar o account ID de `aws_caller_identity` para formar o ARN da LabRole existente, sem `data aws_iam_role` e sem criar IAM

## Tech debt / TODO

## Review lessons
