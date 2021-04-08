provider "azurerm" {
  version = "~>2.0"
  features {}

}
terraform {
  backend "azurerm" {
    resource_group_name  = "var.StorageRG"
    storage_account_name = "var.bakendStorageName"
    container_name       = "var.backend_container"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}"
  // name     = "default_resourcegroup_Name"
  location = "eastus"

}
resource "azurerm_virtual_network" "Vnet"{
  name    = "ismorrvnet2"
  location   = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snet" {
  name  = "default"
  address_prefix  = "10.0.1.0/24"
  virtual_network_name = azurerm_virtual_network.Vnet.name
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_interface" "nic"{
  name = "vmnic"
  location = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
    ip_configuration {
      name                          = "myNicConfiguration"
      subnet_id                     = "${azurerm_subnet.snet.id}"
      private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.hostname}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  os_profile_windows_config {
    provision_vm_agent = true
  }
  storage_image_reference {
    #id = var.image_uri
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name          = "${var.hostname}-osdisk1"
    os_type       = "${var.os_type}"
    caching       = "ReadWrite"
    create_option = "FromImage" 
  }

  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.MYSECRET}"
  }
}

resource "azurerm_managed_disk" "mydisk" {
  name                 = "${var.hostname}-disk1"
  location             =  var.location
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "add-disk" {
  managed_disk_id    = azurerm_managed_disk.mydisk.id
  virtual_machine_id = azurerm_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}

// resource "azurerm_virtual_machine_extension" "vmExtension" {
//   name                 = "hostname"
//   virtual_machine_id   = azurerm_virtual_machine.vm.id
//   publisher            = "Microsoft.Azure.Extensions"
//   type                 = "CustomScript"
//   type_handler_version = "2.0"

//   settings = <<SETTINGS
//     {
//         "commandToExecute": "hostname && uptime"
//     }
// SETTINGS

//   "fileUris": [
//             "https://githubusercontent.com/run.ps1"
//           ]


//   tags = {
//     environment = "Production"
//   }
// }