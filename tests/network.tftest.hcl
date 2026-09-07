mock_provider "aws" {}

run "private_network" {
  command = plan

  override_data {
    target = data.aws_caller_identity.current
    values = { account_id = "924563550535" }
  }

  override_data {
    target = data.aws_vpc.default
    values = { id = "vpc-00000000000000000" }
  }

  override_data {
    target = data.aws_subnets.default
    values = {
      ids = ["subnet-public-a", "subnet-public-b"]
    }
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "A integracao privada exige exatamente duas subnets."
  }

  assert {
    condition = (
      aws_subnet.private["us-east-1a"].cidr_block == "172.31.240.0/24" &&
      aws_subnet.private["us-east-1b"].cidr_block == "172.31.241.0/24"
    )
    error_message = "Os CIDRs devem corresponder ao inventario aprovado."
  }

  assert {
    condition = alltrue([
      for subnet in aws_subnet.private : !subnet.map_public_ip_on_launch
    ])
    error_message = "Subnets privadas nao podem atribuir IP publico."
  }

  assert {
    condition     = length(aws_route_table_association.private) == 2
    error_message = "Cada subnet privada deve usar a route table privada."
  }
}
