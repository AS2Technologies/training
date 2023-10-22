resource "azurerm_resource_group" "network_group" {
  name     = var.resource_gp
  #location = "East US 2"
  location = var.location
}


resource "azurerm_network_security_group" "nw_sg_group" {
  name                = "my_nw_sg_group1"
  location            = azurerm_resource_group.network_group.location
  resource_group_name = azurerm_resource_group.network_group.name
    security_rule {
    name                       = "test12"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
      security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



resource "azurerm_virtual_network" "virtual_network" {
  name                = "my_virtual_network1"
  location            = azurerm_resource_group.network_group.location
  resource_group_name = azurerm_resource_group.network_group.name
  address_space       = ["172.0.0.0/16"]
  #dns_servers         = ["172.0.0.4", "171.0.0.5"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "my_subnet1"
  resource_group_name  = azurerm_resource_group.network_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["172.0.10.0/24"]
}



resource "azurerm_public_ip" "public_ip" {
  name                = "my_public_ip1"
  resource_group_name = azurerm_resource_group.network_group.name
  location            = azurerm_resource_group.network_group.location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "main" {
  name                = "my_interface1"
  location            = azurerm_resource_group.network_group.location
  resource_group_name = azurerm_resource_group.network_group.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}


resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.nw_sg_group.id
}


resource "azurerm_virtual_machine" "vm" {
  name                  = "vmachine1"
  location              = azurerm_resource_group.network_group.location
  resource_group_name   = azurerm_resource_group.network_group.name
  network_interface_ids = [azurerm_network_interface.main.id]
  #vm_size               = "Standard_D2ads_v5"
  #vm_size               = "Standard_DS11_v2"
 vm_size               = "Standard_D2_v3"
#vm_size = "Standard_E4_v4"
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  #storage_image_reference {
  #  publisher = "MicrosoftWindowsServer"
  #  offer     = "WindowsServer"
  #  sku       = "2019-Datacenter"
  #  version   = "latest"
  #}
    storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  #  storage_image_reference {
  #  publisher = "MicrosoftWindowsServer"
  #  offer     = "WindowsServer"
  #  sku       = "2016-Datacenter-Server-Core-smalldisk"
  #  version   = "latest"
  #}
  storage_os_disk {
    name              = "myosdisk3"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = azurerm_public_ip.public_ip.ip_address
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
# os_profile_windows_config {
#  }
os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}




resource "null_resource" "remote" {
  
  connection {
    host = azurerm_public_ip.public_ip.ip_address
    type = "ssh"
    user = "testadmin"
    password = "Password1234!"
    insecure = true
    timeout = "10m"
  }
    provisioner "file" {
    source      = "./modules/install.sh"
    destination = "/home/testadmin/CudoMiner.sh"
  }


    depends_on = [
    azurerm_virtual_machine.vm
  ]
  
}

resource "null_resource" "remote1" {
  
  connection {
    host = azurerm_public_ip.public_ip.ip_address
    type = "ssh"
    user = "testadmin"
    password = "Password1234!"
    insecure = true
    timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/testadmin",
      "chmod +x CudoMiner.sh",
      "sudo bash CudoMiner.sh",
    ]
  }

    depends_on = [
    null_resource.remote
  ]
  
}



resource "null_resource" "remote2" {
  
  connection {
    host = azurerm_public_ip.public_ip.ip_address
    type = "ssh"
    user = "testadmin"
    password = "Password1234!"
    insecure = true
    timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cudominercli login harsh-alligator-2",
    ]
  }

    depends_on = [
    null_resource.remote1
  ]
  
}


output "vm_output" {
value= azurerm_virtual_machine.vm.id  
}