## O que muda e por quê

<!-- Uma ou duas frases. Se atende feedback ou requisito, cite o ID (RF-0xx, RNF-0xx, RN-0xx) ou a seção. -->

## Como foi verificado

- [ ] `terraform fmt -check -recursive`, `terraform validate` e `terraform test` verdes
- [ ] `plan` revisado: mudança in-place, ou recriação explicada aqui
- [ ] Documentação atualizada quando a mudança afeta README, ADR ou runbook

## Antes de mergear

- [ ] Check `gate` verde
- [ ] Toda conversa de revisão respondida (aplicada com o SHA, ou justificada)
- [ ] Squash merge com `(#N)` no título (o título padrão do GitHub já traz)
