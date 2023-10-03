resource "azurerm_virtual_network" "GO-VNET" {
  name                = "${var.workspace}-AVDVNET-01"
  address_space       = [var.azure_vnet_cidr]
  location            = azurerm_resource_group.GO-AVD.location
  resource_group_name = azurerm_resource_group.GO-AVD.name
}

resource "azurerm_subnet" "GO-SUBNET" {
  name                 = "${var.workspace}-AVDVNET-01-subnet01"
  resource_group_name  = azurerm_resource_group.GO-AVD.name
  virtual_network_name = azurerm_virtual_network.GO-VNET.name
  address_prefixes     = [var.azure_vnet_cidr]
}