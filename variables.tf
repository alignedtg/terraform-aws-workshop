variable "public_subnets" {
  description = "List of public subnets to use for the VPC"
  type        = list(string)
}

variable "instance_type" {
  description = "Size of the instance to use"
  type        = string
  default     = "t2.micro"
}