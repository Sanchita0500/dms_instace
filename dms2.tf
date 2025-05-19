resource "aws_dms_replication_instance" "party_comm_replication_instance" {
  replication_instance_id     = "dms-party-comm-${var.env}"
  replication_instance_class  = "dms.t3.medium"
  allocated_storage           = 100
  publicly_accessible         = false
  replication_subnet_group_id = var.replication_subnet_group_id
  vpc_security_group_ids      = var.vpc_security_group_ids
}

resource "aws_dms_replication_task" "party_comm_task" {
  replication_task_id       = "party-comm-task-${var.env}"
  migration_type            = "cdc"
  replication_instance_arn  = aws_dms_replication_instance.party_comm_replication_instance.replication_instance_arn
  source_endpoint_arn       = aws_dms_endpoint.oracle_source_endpoint.endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.dynamo_target_endpoint.endpoint_arn
  table_mappings            = file("${path.module}/mapping_comm.json")
  replication_task_settings = file("${path.module}/replication_settings.json")
}
