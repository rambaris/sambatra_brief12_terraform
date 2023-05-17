//Load balancer
resource "azurerm_public_ip" "load_ip" {
  name                = "load-ip"
  resource_group_name = var.rgname
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "app_balancer" {
  name                = "app-balancer"
  resource_group_name = var.rgname
  location            = var.location
  sku                 = "Standard"
  sku_tier            = "Regional"
  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.load_ip.id
  }

  depends_on = [
    azurerm_public_ip.load_ip
  ]
}

//Backendpool
resource "azurerm_lb_backend_address_pool" "PoolA" {
  loadbalancer_id = azurerm_lb.app_balancer.id
  name            = "PoolA"
  depends_on = [
    azurerm_lb.app_balancer
  ]
}

resource "azurerm_lb_backend_address_pool_address" "appvm1_address" {
  name                    = "appvm1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.PoolA.id
  virtual_network_id      = azurerm_virtual_network.app_network.id
  ip_address              = azurerm_network_interface.app_interface1.private_ip_address
  depends_on = [
    azurerm_lb_backend_address_pool.PoolA
  ]
}

resource "azurerm_lb_backend_address_pool_address" "appvm2_address" {
  name                    = "appvm2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.PoolA.id
  virtual_network_id      = azurerm_virtual_network.app_network.id
  ip_address              = azurerm_network_interface.app_interface2.private_ip_address
  depends_on = [
    azurerm_lb_backend_address_pool.PoolA
  ]
}

// Health Probe
resource "azurerm_lb_probe" "ProbeA" {
  
  loadbalancer_id = azurerm_lb.app_balancer.id
  name            = "probeA"
  port            = 80
  protocol        = "Tcp"
  depends_on = [
    azurerm_lb.app_balancer
  ]
}

// Here we are defining the Load Balancing Rule
resource "azurerm_lb_rule" "RuleA" {
  
  loadbalancer_id                = azurerm_lb.app_balancer.id
  name                           = "RuleA"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.PoolA.id]
  depends_on = [
    azurerm_lb.app_balancer
  ]
}

// This is used for creating the NAT Rules

resource "azurerm_lb_nat_rule" "NATRuleA" {
  resource_group_name            = var.rgname
  loadbalancer_id                = azurerm_lb.app_balancer.id
  name                           = "ssh-nat-rule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "frontend-ip"
  depends_on = [
    azurerm_lb.app_balancer
  ]
}
