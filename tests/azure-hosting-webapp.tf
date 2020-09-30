module "azure_webapp" {
  source              = "../azure/webapp"
  app_name            = "test"
  location            = "test"
  environment         = "test"
  resource_group_name = "test"
  random_key          = "test"
}
