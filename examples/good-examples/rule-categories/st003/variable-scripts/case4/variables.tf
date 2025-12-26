variable "data_volumes_configuration" {
  description = "The configuration of the data volumes"
  type        = list(object({
    volumetype     = string
    size           = number
    count          = number
    kms_key_id     = optional(string, null)
    extend_params  = optional(map(string), null)
    virtual_spaces = optional(list(object({
      name            = string
      size            = string
      lvm_lv_type     = optional(string, null)
      lvm_path        = optional(string, null)
      runtime_lv_type = optional(string, null)
    })), [])
  }))

  default = [
    {
      volumetype = "SSD"
      size       = 100
      count      = 1
    }
  ]

  validation {
    condition     = length(var.data_volumes_configuration) > 0
    error_message = "At least one data volume must be provided."
  }
}
