variable "vpc_id" {
    type = string
}

variable "my_ip"{
    type = string
    description = "provide CIDR block of IP"
}


variable "EC2-Key" {
    type = string
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "server_name" {
    type = string
    default = "Apache-Server"
}