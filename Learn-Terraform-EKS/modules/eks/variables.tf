variable "project" {
}
variable "env" {
}
variable "eks_cluster_version" {
}
variable "instance_types" {
}
variable "desired_size" {
}
variable "max_size" {
}
variable "min_size" {
}
variable "max_unavailable" {
}


variable "subnet_private_1a" {
    type = string
}
variable "subnet_private_1b" {
    type = string
}
variable "subnet_public_1a" {
    type = string
}
variable "subnet_public_1b" {
    type = string
}
