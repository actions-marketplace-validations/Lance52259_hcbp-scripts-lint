resource "huaweicloud_eg_event_subscription" "test" {
  channel_id = huaweicloud_eg_custom_event_channel.test.id
  name       = var.subscription_name

  sources {
    name          = huaweicloud_eg_custom_event_channel.test.name
    provider_type = var.sources_provider_type

    filter_rule = jsonencode({
      "source" : [
        {
          "op" : var.source_op,
          "values" : [huaweicloud_eg_custom_event_channel.test.name]
        }
      ]
    })
  }

  targets {
    name          = var.targets_name
    provider_type = var.targets_provider_type
    connection_id = try(data.huaweicloud_eg_connections.test.connections[0].id, "")
    transform     = jsonencode(var.transform)
    detail_name   = var.detail_name
    detail        = jsonencode({
      "url" : var.target_url
    })
  }

  lifecycle {
    ignore_changes = [
      sources, targets
    ]
  }

  depends_on = [
    time_sleep.test
  ]
}
