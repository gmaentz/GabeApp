resource "azurerm_virtual_machine" "training" {
  name                  = "${var.prefix}vm"
  location              = azurerm_resource_group.training.location
  resource_group_name   = azurerm_resource_group.training.name
  network_interface_ids = [azurerm_network_interface.training.id]
  vm_size               = "Standard_F2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "file" {
    connection {
      host     = azurerm_public_ip.training.fqdn
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
    }

    source      = "hello.py"
    destination = "hello.py"
  }

  provisioner "remote-exec" {
    connection {
      host     = azurerm_public_ip.training.fqdn
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
    }

    inline = [
      "python3 -V",
      "sudo apt update",
      "sudo apt install -y python3-pip python3-flask",
      "python3 -m flask --version",
      "sudo FLASK_APP=hello.py nohup flask run --host=0.0.0.0 --port=8000 &",
      "sleep 1"
    ]
  }

  tags = {
    environment = var.EnvironmentTag
  }
}