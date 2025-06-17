# K3s SQL Username
variable "SQL_USER" {
  type        = string
  default     = ""
  description = "SQL username"
}
# K3s SQL Password
variable "SQL_PASSWORD" {
  type        = string
  default     = ""
  description = "SQL password"
}
# K3s SQL Database
variable "SQL_DATABASE" {
  type        = string
  default     = ""
  description = "SQL database name for K3s"
}
# K3s Cluster Token
variable "CLUSTER_TOKEN" {
  type        = string
  default     = ""
  description = "K3s cluster token for authentication"
}