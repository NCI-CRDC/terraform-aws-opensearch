module "opensearch" {
  source = "git::https://github.com/NCI-CRDC/terraform-aws-opensearch"

  app                              = "my-app"
  env                              = "prod"
  program                          = "my-program"
  automated_snapshot_start_hour    = 23
  availability_zone_count          = 2
  cloudwatch_error_log_group       = aws_cloudwatch_log_group.opensearch_error_logs.arn
  cloudwatch_index_slow_log_group  = aws_cloudwatch_log_group.opensearch_index_logs.arn
  cloudwatch_search_slow_log_group = aws_cloudwatch_log_group.opensearch_search_logs.arn
  cold_storage_enabled             = false
  create_domain_policy             = true
  create_service_linked_role       = true
  dedicated_master_count           = null
  dedicated_master_enabled         = false
  dedicated_master_type            = null
  domain_name_suffix               = "opensearch"
  ebs_enabled                      = true
  ebs_iops                         = 3000
  ebs_throughput                   = 125
  ebs_volume_size                  = 10
  ebs_volume_type                  = "gp3"
  engine_version                   = "OpenSearch_2.3"
  instance_count                   = 1
  instance_type                    = "m6g.large.search"
  security_group_ids               = [aws_security_group.opensearch.id]
  subnet_ids                       = sort(tolist(data.aws_subnets.database.ids))
  warm_count                       = null
  warm_enabled                     = false
  warm_type                        = null
  zone_awareness_enabled           = true
}

resource "aws_cloudwatch_log_group" "opensearch_error_logs" {
  name              = "opensearch-error-logs"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "opensearch_index_logs" {
  name              = "opensearch-index-logs"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "opensearch_search_logs" {
  name              = "opensearch-search-logs"
  retention_in_days = 90
}

resource "aws_security_group" "opensearch" {
  name        = "prod-opensearch-sg"
  description = "Security group for prod opensearch"
  vpc_id      = data.aws_vpc.vpc.id
}

data "aws_subnets" "public" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["*-db-*"]
  }
}

data "aws_vpc" "vpc" {

  filter {
    name   = "tag:Name"
    values = ["*prod*"]
  }
}
