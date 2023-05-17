#project variables
variable "rgname" {
  type        = string
  description = "name of the resource group"
}

variable "location" {
  type        = string
  description = "location of the RG"
  default     = "West Europe"
}


