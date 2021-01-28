provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "training" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "training" {
  name                = "${var.prefix}-azurevn"
  address_space       = var.address_space
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
}

resource "azurerm_subnet" "training" {
  name                 = "${var.prefix}-azuresub"
  resource_group_name  = azurerm_resource_group.training.name
  virtual_network_name = azurerm_virtual_network.training.name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_public_ip" "training" {
  name                    = "${var.prefix}-azureip"
  location                = azurerm_resource_group.training.location
  resource_group_name     = azurerm_resource_group.training.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label       = lower(var.prefix)
}

resource "azurerm_network_interface" "training" {
  name                = "${var.prefix}-azureni"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name

  ip_configuration {
    name                          = "${var.prefix}-azureip"
    subnet_id                     = azurerm_subnet.training.id
    private_ip_address_allocation = "static"
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = azurerm_public_ip.training.id
  }
}