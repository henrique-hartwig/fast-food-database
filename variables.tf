variable "db_name" {
  default = "fastfood"
}
variable "db_username" {
  default = "postgres"
}
variable "db_password" {
  sensitive = true
}
variable "db_instance_class" {
  default = "db.t3.micro"
}
variable "db_storage" {
  default = 20
}
variable "db_engine" {
  default = "postgres"
}
variable "db_engine_version" {
  default = "17.4"
}
variable "db_port" {
  default = 5432
}
variable "db_multi_az" {
  default = false
}
variable "aws_region" {
  default = "us-east-1"
}
variable "project_name" {
  default = "fastfood"
}