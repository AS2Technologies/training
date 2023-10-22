terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" 
      version = "=3.0.0"
    }

  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" { 
    features{}



#run for 2
client_id = "63751d74-a47a-4236-82da-730543a10243"
client_secret = "1I28Q~HcltVrUXdAo.KTQtLMHRhdCQeyeQnj5c4r"
tenant_id = "f542f903-8530-4254-aa59-34aa2dcb3bc3"
subscription_id = "2146ae1f-7d1d-4dbf-828b-54f9ca42f169"

# RUN AFTER 1 month
#   client_id       = "5a86291c-f33c-4b25-b385-615a1f3d93c8"
#   client_secret   = "kjl8Q~b9YRo1_hg96.4nV2eitl_4lgQFDBCMgaia"
#   tenant_id       = "bbf8976b-3f62-4e78-9276-93c19a5f8ebd"
#   subscription_id = "60afa1f0-ff2d-42e5-9207-64d9c1dc5f06"

  }

