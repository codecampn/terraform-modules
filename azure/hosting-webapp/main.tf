# Create a azure storage account
resource "azurerm_storage_account" "frontend_application" {
  name                = "${var.environment}${var.app_name}${var.random_key}"
  resource_group_name = var.resource_group_name

  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"

  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }
}
# Create a azure cdn profile
resource "azurerm_cdn_profile" "frontend_application" {
  depends_on          = [azurerm_storage_account.frontend_application]
  name                = "${var.environment}${var.app_name}${var.random_key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard_Microsoft"
}

# Create a azure cdn endpoint
resource "azurerm_cdn_endpoint" "frontend_application" {
  depends_on          = [azurerm_cdn_profile.frontend_application]
  name                = "${var.environment}${var.app_name}${var.random_key}"
  profile_name        = azurerm_cdn_profile.frontend_application.name
  location            = var.location
  resource_group_name = var.resource_group_name
  is_http_allowed     = false

  # compression configuration
  content_types_to_compress = ["text/plain", "text/html", "text/css", "text/javascript", "application/x-javascript", "application/javascript", "application/json", "application/xml"]
  is_compression_enabled    = true

  origin_host_header = azurerm_storage_account.frontend_application.primary_web_host

  origin {
    name      = "${var.environment}${var.app_name}${var.random_key}"
    host_name = azurerm_storage_account.frontend_application.primary_web_host
  }
}

