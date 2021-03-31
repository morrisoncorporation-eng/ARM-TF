variable "location" {
  default     = "Eastus"
  description = "The location where resources are created"
}
variable "vm_size" {
  default = "Standard_DS1_v2"
}
variable "hostname" {
  default = "myterrafvm"
}
variable "os_type" {
  default = "windows"
}
variable "admin_username" {
  default = "Azureadmin"
}
variable key_vault_name {
  description = "Name of the keyVault"
  default     = "testkeyVault123"
}
variable "subscription_id" {
  default = "$(subscription_id)"
}
variable "MYSECRET" {
  type = string
}
variable "rgname" {
  type = string
}
