output "rg" {
  description = "Name of RG"
  value = "The name of the RG is ${var.rgname}"
}

/* output "IP" {
    description = "The IP-addresses are"
    value = "The IP-address for the VMs: ${azurerm_network_interface.app_interface2.*.ip_address}"
} */