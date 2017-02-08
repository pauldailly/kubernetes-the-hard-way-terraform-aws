variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-98ecb7fe"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "kubernetes_ec2_key"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "kubernetes_ec2_key.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
