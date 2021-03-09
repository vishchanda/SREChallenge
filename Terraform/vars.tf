variable "region" {
  default = "us-east-2"
}

variable "vpc_cidrblock" {
  default = "10.10.0.0/16"
}

variable "ansible_user" {
   default = "ec2-user"
}
variable "azs" {
  type    = "list"
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "demo_priv_subnets" {
  type    = "list"
  default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "demo_pub_subnets" {
  type    = "list"
  default = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
}
variable "num_webservers" {
  default = "1"
}

variable "key_name" {
  default = "~/.ssh/devops.pem"
}

variable "public_key_path" {
  default = "~/.ssh/devops.pem.pub"
}

variable "server_http_port" {
  default = "80"
}

variable "server_https_port" {
  default = "443"
}

variable "elb_http_port" {
  default = "80"
}

variable "elb_https_port" {
  default = "443"
}

variable "private_key" {
  default = "/opt/cert/demo-key.pem"
}

variable "cert" {
  default = "/opt/cert/demo-crt.pem"
}
