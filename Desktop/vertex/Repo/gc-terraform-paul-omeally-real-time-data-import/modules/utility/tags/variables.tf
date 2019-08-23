variable "environment_type" { }

variable "service" {}

variable "resource_type" {
    default = ""
 }

variable "resource_name" {
    default = ""
 }

 variable "additional_attributes" {
     type = "map"
     default = {}
 }