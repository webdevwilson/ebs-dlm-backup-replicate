// Create snapshot replication stack in the live region
resource "aws_cloudformation_stack" "live_region" {
  name          = "ebs-snapshot-replicator"
  template_body = "${file("${path.module}/cfn/live_region.cfn.yml")}"
  capabilities  = ["CAPABILITY_NAMED_IAM"]

  parameters {
    ReplicationRegion   = "${var.replication_region}"
    ReplicationTag      = "replicate"
    ReplicationTagValue = "true"
    SnapshotRetention   = "${local.snapshot_retention}"
    LogRetentionInDays  = "${local.log_retention_in_days}"
  }
}

// Create the pruner in the dr region
resource "aws_cloudformation_stack" "replication_region" {
  provider      = "aws.dr"
  name          = "ebs-snapshot-pruner"
  template_body = "${file("${path.module}/cfn/replication_region.cfn.yml")}"
  capabilities  = ["CAPABILITY_NAMED_IAM"]

  parameters {
    SnapshotRetention  = "${local.snapshot_retention}"
    LogRetentionInDays = "${local.log_retention_in_days}"
  }
}
