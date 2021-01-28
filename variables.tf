variable "resource_group_name" {}
variable "EnvironmentTag" {}
variable "prefix" {}
variable "location" {
  default = "East US"
}
variable computer_name {}
variable admin_username {}
variable admin_password {}
variable "address_space" {
  type        = list
  description = "virtual network"
}
variable "address_prefixes" {
  type        = list
  description = "Subnet Address"
}

variable "private_ip_address" {
  type        = string
  description = "Private IP for Server"
}

variable "MessageOfTheDay" {
  type        = string
  description = "Message of the Day"
}
