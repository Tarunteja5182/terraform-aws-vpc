variable "vpc_cidr"{
    type = string
}

variable "project"{
    type= string
}

variable "environment"{
    type= string
}

variable "vpc_tags"{
    type = map
    default={}
}

