variable "network" {
  type = object({
    cidr_block      = string
    public_subnets  = list(string)
    private_subnets = list(string)
  })
  default = {
    cidr_block      = "10.1.0.0/16"
    private_subnets = ["10.1.0.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    public_subnets  = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
  }
}

variable "tags" {
  type = map(string)
  default = {
    Createdby = "Terraform"
    Team      = "DevOPS"
  }
  description = "AWS resource tags"
}

variable "aws_region" {
  description = "AWS Region"
  default     = ""
}