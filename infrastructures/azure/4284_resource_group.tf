resource "azurerm_resource_group" "4284_rg" {
    name     = "4284_workspace"
    location = "Korea Central"

    tags {
        environment = "4284_secret"
    }
}