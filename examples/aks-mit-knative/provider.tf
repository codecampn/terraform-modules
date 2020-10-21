terraform {
  # backend "azurerm" {
  #   resource_group_name   = "central-buml-rg"
  #   storage_account_name  = "bumlxterraformxq4sdzk"
  #   container_name        = "tfstate"
  #   key                   = "infrastructure.terraform.tfstate"
  #   subscription_id       = "bd6863ee-44db-4efb-80c1-b850c53a8bf9"

  # }
}

provider "azurerm" {
  version = "=2.20.0"
  features {}
}
