variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
variable "db_instance_class" {}
variable "db_storage" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_port" {}
variable "db_multi_az" {}
variable "aws_region" {}