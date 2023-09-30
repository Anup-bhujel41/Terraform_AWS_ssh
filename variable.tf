variable "access_key" {}
variable "secret_key" {}

#variable "key_name" {}



variable "region" {
    default = "ap-south-1"
}


variable "ami_id" {
    type = map(string)
    default = {
        ap-south-1 = "ami-0f5ee92e2d63afc18"
        us-east-1 = "ami-053b0d53c279acc90"
        us-east-2 = "ami-024e6efaf93d85776"
    }
}

variable "ssh_port" {
    description = "This is ssh_port"
    default = 22
}
variable "jenkins_port" {
    description = "This is jenkins_port"
    default = 8080
}
variable "http_port" {
    description = "This is http_port"
    default = 80
}
variable "https_port" {
    description = "This is https_port"
    default = 443
}