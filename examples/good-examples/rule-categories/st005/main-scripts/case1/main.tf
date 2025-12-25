locals {
  flattened_root_volumes                                 = flatten([for v in var.data_volumes_configuration : v if v.volumetype != "SATA"])
  flattened_data_volumes                                 = flatten([
    for v in var.data_volumes_configuration : [
      for i in range(v.count) : {
        volumetype    = v.volumetype
        size          = v.size
        kms_key_id    = v.kms_key_id
        extend_params = v.extend_params
      }
    ]
  ])
  default_data_volumes_configuration_with_virtual_spaces = [
    for v in slice(var.data_volumes_configuration, 0, 1) : v if length(v.virtual_spaces) > 0
  ]
  user_data_volumes_configuration_with_virtual_spaces    = [
    for i, v in  [
      for v in slice(var.data_volumes_configuration, 1, length(var.data_volumes_configuration)) : v if length(v.virtual_spaces) > 0
    ] : {
      select_name    = "user${i+1}"
      volumetype     = v.volumetype
      size           = v.size
      count          = v.count
      kms_key_id     = v.kms_key_id
      extend_params  = v.extend_params
      virtual_spaces = v.virtual_spaces
    }
  ]
}
