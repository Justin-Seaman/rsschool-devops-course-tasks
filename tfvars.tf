# K3s SQL Username
variable "SQL_USER" {
  type        = string
  description = "SQL username"
}
# K3s SQL Password
variable "SQL_PASSWORD" {
  type        = string
  description = "SQL password"
}
# K3s SQL Database
variable "SQL_DATABASE" {
  type        = string
  description = "SQL database name for K3s"
}
# K3s Cluster Token
variable "CLUSTER_TOKEN" {
  type        = string
  description = "K3s cluster token for authentication"
}