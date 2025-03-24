variable "region_east" {
  description = "Región de AWS para la primera instancia"
  default     = "us-east-1"
}

variable "region_west" {
  description = "Región de AWS para la segunda instancia"
  default     = "us-west-1"
}

variable "instance_type" {
  description = "Tipo de instancia de AWS"
  default     = "t2.micro"
}

variable "vpc_cidr_east" {
  description = "CIDR de la VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_west" {
  description = "CIDR de la VPC"
  default     = "10.1.0.0/16"
}

variable "subnet_east_cidr" {
  description = "CIDR de la Subnet en us-east-1"
  default     = "10.0.1.0/24"
}

variable "subnet_west_cidr" {
  description = "CIDR de la Subnet en us-west-1"
  default     = "10.1.1.0/24"
}
