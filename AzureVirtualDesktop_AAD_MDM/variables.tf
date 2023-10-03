variable "deployment_name" {
  type        = string
  description = "Name of the deployement. I.e. GOLAB"
  default     = "GOLAB"
}

variable "workspace" {
  type        = string
  description = "Name of the Terraform workspace. I.e. POIS, FLOW, CARD"
  default     = "POIS"
}

variable "location" {
  type        = string
  description = "Name of the Location"
  default     = "West Europe"
}

variable "sessionhost_amount" {
  type        = number
  description = "Amount of session hosts"
  default     = 2
}

variable "sessionhost_sku" {
  type        = string
  description = "IaaS VM SKU Size for Session Host"
  default     = "Standard_D4s_v5"
}

variable "azure_vnet_cidr" {
  description = "CIDR adres of VNET"
  type        = string
  default     = "10.13.4.0/24"
}

variable "local_admin" {
  description = "Local administrator"
  type        = string
  default     = "lcladmin"
}

variable "avd_users" {
  description = "Users with access to the AVD Desktop"
  default = [
    "patrick@vandenborn.it",
    "kelly@vandenborn.it"
  ]
}


