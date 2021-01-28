output "app-URL" {
  value = "http://${azurerm_public_ip.training.fqdn}:8000"
}