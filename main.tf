module "instances" {
  count = length(var.location)
  source = "./modules"
  location = var.location[count.index]
  resource_gp = "group${count.index}003"
}





