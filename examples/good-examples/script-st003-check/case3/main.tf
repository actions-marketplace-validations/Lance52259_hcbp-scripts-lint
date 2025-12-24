resource "huaweicloud_obs_bucket" "test" {
  bucket        = var.bucket_name
  storage_class = var.bucket_storage_class
  acl           = var.bucket_acl
  encryption    = var.bucket_encryption
  sse_algorithm = var.bucket_encryption ? var.bucket_sse_algorithm : null
  kms_key_id    = var.bucket_encryption ? var.bucket_encryption_key_id != "" ? var.bucket_encryption_key_id : huaweicloud_kms_key.test[0].id : null
  force_destroy = alltrue([for o in var.objects_force_destroy_limits : o.enabled && (o.object_name == "*" || o.object_name_prefix == "**")])
  tags          = merge(var.bucket_tags, {for k, v in var.website_configurations : k => v.file_name if k == "index" || k == "error"})

  provisioner "local-exec" {
    command = "echo '${lookup(local.index_page, "content")}' >> ${lookup(local.index_page, "file_name")}\necho '${lookup(local.error_page, "content")}' >> ${lookup(local.error_page, "file_name")}"
  }
  provisioner "local-exec" {
    command = "rm ${self.tags.index} ${self.tags.error}"
    when    = destroy
  }

  website {
    index_document = lookup(local.index_page, "file_name")
    error_document = lookup(local.error_page, "file_name")
  }

  lifecycle {
    ignore_changes = [
      sse_algorithm
    ]
  }
}
