locals{
    common_tags = {
        project= var.project
        evn = var.environment
        terraform = "true"
    }
    vpc_final_tags =  merge(
                            local.common_tags,
                            {
                                Name = "${var.project}-${var.environment}"
                            },
                            var.vpc_tags)
    az_names = slice(data.aws_availability_zones.available.names, 0, 2)
}