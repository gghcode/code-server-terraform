provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  	version = "=1.24.0"
  	subscription_id = <subscription_id>
	client_id       = <client_id>
    client_secret   = <client_secret>
    tenant_id       = <tenant_id>
}