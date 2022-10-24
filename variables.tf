variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to add to deployed resources"
}