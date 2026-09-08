# Operação do cluster EKS da fase 3. Pré-requisitos para plan/apply:
# sessão do AWS Academy ativa e credenciais na cadeia padrao
# (runbook aws-academy-setup.md, repo postech-sw-arch-p3-docs).
#
# `make gate` roda só o que não precisa de AWS (fmt-check + validate + test) — é o
# mesmo check do CI e deve passar antes de qualquer commit.

.PHONY: fmt fmt-check init validate test gate plan apply destroy kubeconfig

fmt: ## Formata os arquivos .tf in-place
	terraform fmt -recursive

fmt-check: ## Falha se algum .tf estiver fora do formato canônico
	terraform fmt -check -recursive

init: ## Init sem backend para validacao offline
	terraform init -backend=false

validate: init ## Valida sintaxe e referências (não toca a AWS)
	terraform validate

test: init ## Valida contratos Terraform com provider mockado
	terraform test

gate: fmt-check validate test ## Gate local = CI: fmt-check + validate + test

plan: ## Plan contra a conta Academy (exige sessão de lab ativa)
	terraform init
	terraform plan

apply: ## Cria o cluster (~10-15 min) para a janela de preparação/gravação
	terraform init
	terraform apply

destroy: ## Remove a infra cobrada ao final da gravação (budget, ADR-026)
	terraform init
	terraform destroy

# Fallback sem consultar o state:
#   aws eks update-kubeconfig --name pytstop-p3 --region us-east-1
kubeconfig: ## Funde o kubeconfig do cluster no ~/.kube/config
	terraform output -raw update_kubeconfig_command | sh
