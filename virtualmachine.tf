//VM1
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "virtual-machine-1"
  resource_group_name = var.rgname
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.app_interface1.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-lts"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.app_interface1
  ]

}

//VM2
resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "virtual-machine-2"
  resource_group_name = var.rgname
  location            = var.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.app_interface2.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-lts"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.app_interface2
  ]
}
