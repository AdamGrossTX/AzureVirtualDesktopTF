locals {
  add_registry_key   = "New-Item -Path HKLM:/SOFTWARE/Microsoft/RDInfraAgent/AADJPrivate"
  restart_vm         = "shutdown -r -t 10"
  exit_code          = "exit 0"
  powershell_command = "${local.add_registry_key}; ${local.restart_vm}; ${local.exit_code}"
}

resource "azurerm_virtual_machine_extension" "avd_register_session_host" {
  count                = var.sessionhost_amount
  name                 = "avd-${count.index + 1}-GOEUC-register-session-host"
  virtual_machine_id   = azurerm_windows_virtual_machine.sessionhostvms.*.id[count.index]
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<SETTINGS
    {
        "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
        "ConfigurationFunction": "Configuration.ps1\\AddSessionHost",
        "Properties" : {
          "hostPoolName" : "${azurerm_virtual_desktop_host_pool.hostpool.name}",
          "aadJoin": true
        }
    }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "properties": {
        "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.token.token}"
      }
    }
    PROTECTED_SETTINGS

    depends_on = [
    azurerm_virtual_desktop_host_pool.hostpool
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_virtual_machine_extension" "avd_aadloginforwindows" {
  depends_on = [
    azurerm_virtual_machine_extension.avd_register_session_host
  ]
  count                      = var.sessionhost_amount
  name                       = "avd-${count.index + 1}-GOEUC-AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.sessionhostvms.*.id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "mdmId" : "0000000a-0000-0000-c000-000000000000"
    }
    SETTINGS

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_virtual_machine_extension" "avd_addaadjprivate" {
  depends_on = [
    azurerm_virtual_machine_extension.avd_aadloginforwindows
  ]
  count                      = var.sessionhost_amount
  name                 = "avd-${count.index + 1}-GOEUC-AADJPRIVATE"
  virtual_machine_id   = azurerm_windows_virtual_machine.sessionhostvms.*.id[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
    SETTINGS

  lifecycle {
    ignore_changes = all
  }
}