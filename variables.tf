variable "instance_type" {
  description = "The type of instance to use for the EC2 instance."
  type        = string
  default     = "t2.micro"


}

locals {
  instance_ami="ami-0a94c8e4ca2674d5a"
}




