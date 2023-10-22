#!/bin/bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_linux_386.zip
https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_linux_amd64.zip
https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_linux_arm.zip
https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_linux_arm64.zip