resource "huaweicloud_apig_plugin" "test" {
  instance_id = huaweicloud_apig_instance.test.id
  name        = var.plugin_name
  description = var.plugin_description
  type        = "kafka_log"

  content = jsonencode({
    broker_list     = var.kafka_security_protocol == "PLAINTEXT" ? (split(",", huaweicloud_dms_kafka_instance.test.port_protocol[0].private_plain_address)) : var.kafka_security_protocol == "SASL_PLAINTEXT" ? (split(",",huaweicloud_dms_kafka_instance.test.port_protocol[0].private_sasl_plaintext_address)) : (split(",", huaweicloud_dms_kafka_instance.test.port_protocol[0].private_sasl_ssl_address))
    topic           = var.kafka_topic_name
    key             = var.kafka_message_key
    max_retry_count = var.kafka_max_retry_count
    retry_backoff   = var.kafka_retry_backoff

    sasl_config = {
      security_protocol = var.kafka_security_protocol
      sasl_mechanisms   = var.kafka_sasl_mechanisms
      sasl_username     = var.kafka_sasl_username != "" ? nonsensitive(var.kafka_sasl_username) : (var.kafka_security_protocol == "PLAINTEXT" ? "" : nonsensitive(var.kafka_access_user))
      sasl_password     = var.kafka_sasl_password != "" ? nonsensitive(var.kafka_sasl_password) : (var.kafka_security_protocol == "PLAINTEXT" ? "" : nonsensitive(var.kafka_password))
      ssl_ca_content    = var.kafka_ssl_ca_content != "" ? nonsensitive(var.kafka_ssl_ca_content) : ""
    }
  })

  lifecycle {
    ignore_changes = [
      content,
    ]
  }
}
