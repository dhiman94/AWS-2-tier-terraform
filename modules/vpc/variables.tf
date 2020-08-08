variable "public_subnet_cidrs" {
  type        = list(string)
  description = "list of public subnet cidr blocks"
  default     = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "list of private subnet cidr blocks"
  default     = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}
