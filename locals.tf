locals{
    common_tags = {
        project= var.project
        evn = var.environment
        terraform = "true"
    }
    vpc_final_tags =  merge(local.common_tags,${var.project}-${var.environment},var.vpc_tags)
}