# ASG Instance Type
variable "type" {
  default     = "t3.micro"
  type        = string
  description = "Dev Environment Instances Type"
}




# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "dev environment"
}