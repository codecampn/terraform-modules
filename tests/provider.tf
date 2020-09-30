provider "aws" {
  region = "eu-central-1"
}

# Configure the Azure Provider
provider "azurerm" {
  version         = "=2.20.0"
  subscription_id = ""

  features {}
}
