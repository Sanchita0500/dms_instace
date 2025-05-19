resource "aws_dms_replication_instance" "party_replication_instance" {
  replication_instance_id     = "dms-party-${var.env}"
  replication_instance_class  = "dms.t3.medium"
  allocated_storage           = 100
  publicly_accessible         = false
  replication_subnet_group_id = var.replication_subnet_group_id
  vpc_security_group_ids      = var.vpc_security_group_ids
}

resource "aws_dms_endpoint" "oracle_source_endpoint" {
  endpoint_id       = "oracle-source-${var.env}"
  endpoint_type     = "source"
  engine_name       = "oracle"
  username          = var.oracle_username
  password          = var.oracle_password
  server_name       = var.docdb_host
  port              = 1521
  database_name     = var.docdb_service_name
  ssl_mode          = "none"
  extra_connection_attributes = "useLogminerReader=N;useBfile=0;retryInterval=5;maxRetryDuration=60;"
}

resource "aws_dms_endpoint" "dynamo_target_endpoint" {
  endpoint_id         = "dynamo-target-${var.env}"
  endpoint_type       = "target"
  engine_name         = "dynamodb"
  service_access_role = aws_iam_role.dms_access_for_dynamodb.arn
}

resource "aws_dms_replication_task" "party_task" {
  replication_task_id       = "party-task-${var.env}"
  migration_type            = "cdc"
  replication_instance_arn  = aws_dms_replication_instance.party_replication_instance.replication_instance_arn
  source_endpoint_arn       = aws_dms_endpoint.oracle_source_endpoint.endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.dynamo_target_endpoint.endpoint_arn
  table_mappings            = file("${path.module}/mapping_party.json")
  replication_task_settings = file("${path.module}/replication_settings.json")
}
