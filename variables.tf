variable "env" {}
variable "region" {}
variable "dynamo_table_name" {}
variable "oracle_username" {
  description = "Oracle DB username (e.g., dms_reader)"
  default     = "dms_reader"
}
variable "oracle_password" {
  description = "Password for Oracle user"
  sensitive   = true
}
variable "docdb_host" {
  description = "Hostname of Oracle RDS (docdb)"
}
variable "docdb_service_name" {
  description = "Oracle DB service name (e.g., ORCL)"
}
variable "dms_replication_role_arn" {}
variable "replication_subnet_group_id" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
