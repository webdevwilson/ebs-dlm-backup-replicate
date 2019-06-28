variable "replication_region" {}

provider "aws" {
  alias = "dr"
}

locals {
  log_retention_in_days = 14
  snapshot_retention    = 14
}
