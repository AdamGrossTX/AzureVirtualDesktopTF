resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  location            = azurerm_resource_group.GO-AVD.location
  resource_group_name = azurerm_resource_group.GO-AVD.name

  name                             = "vdpool-${var.deployment_name}-${var.workspace}"
  friendly_name                    = "This is our lab AVD host pool in ${var.location}"
  type                             = "Personal"
  load_balancer_type               = "Persistent"
  description                      = "${var.deployment_name}: A personal host pool - Persistent"
  validate_environment             = true
  start_vm_on_connect              = true
  personal_desktop_assignment_type = "Automatic"

  tags = {
    "description" = "${var.deployment_name}: A Personal host pool - Persistent"
  }
}