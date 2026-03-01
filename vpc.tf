resource "aws_vpc" "mod_vpc"{
    cidr_block= var.cidr_blocks
    instance_tenancy = "default"
    enable_dns_hostnames= "true"
    tags = local.vpc_final_tags
}