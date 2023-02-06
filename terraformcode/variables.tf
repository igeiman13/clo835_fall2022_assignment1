variable "network_interface_id" {
  type = string
  default = "network_id_from_aws"
}


variable "instance_type" {
    type = string
    default = "t2.micro"
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "akashassig environment"
}
