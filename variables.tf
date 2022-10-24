variable "prefix" {
  type        = string
  description = "Prefix used in Azure resources naming convention"
}
variable "service" {
  type        = string
  description = "Service name used in Azure resources naming convention"
}
variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}
variable "default_tags" {
  type        = map(string)
  description = "Default tags to add to deployed resources"
}

variable "image_details" {
  type        = map(string)
  description = "Image dettails, i.e. Publisher, Offer and SKU"
}