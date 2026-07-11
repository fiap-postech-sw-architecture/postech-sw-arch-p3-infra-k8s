# Operação do cluster EKS da fase 3. Pré-requisitos para plan/apply:
# sessão do AWS Academy ativa e credenciais copiadas para o profile
# "academy" (runbook aws-academy-setup.md, repo postech-sw-arch-p3-docs).
#
# `make gate` roda só o que não precisa de AWS (fmt + validate) — é o
# mesmo check do CI e deve passar antes de qualquer commit.

.PHONY: fmt fmt-check init validate gate plan apply destroy kubeconfig

fmt: ## Formata os arquivos .tf in-place
	terraform fmt -recursive

fmt-check: ## Falha se algum .tf estiver fora do formato canônico
	terraform fmt -check -recursive

init: ## Init sem backend (state local; ADR-026)
	terraform init -backend=false

validate: init ## Valida sintaxe e referências (não toca a AWS)
	terraform validate

gate: fmt-check validate ## Gate local = CI: fmt-check + validate

plan: ## Plan contra a conta Academy (exige sessão de lab ativa)
	terraform init
	terraform plan

apply: ## Cria o cluster (~10-15 min). Lembre do destroy pós-demo!
	terraform init
	terraform apply

destroy: ## OBRIGATÓRIO pós-demo (budget pequeno, ADR-026)
	terraform destroy

kubeconfig: ## Funde o kubeconfig do cluster no ~/.kube/config
	aws eks update-kubeconfig --name pytstop-p3 --profile academy --region us-east-1
