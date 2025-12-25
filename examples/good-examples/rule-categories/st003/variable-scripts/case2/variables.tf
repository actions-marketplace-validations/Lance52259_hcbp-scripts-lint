variable "response_rules" {
  description = "The response rules of the dedicated APIG"
  type        = list(object({
    error_type  = string
    body        = string
    status_code = optional(number, null)
    headers     = optional(list(object({
      key   = string
      value = string
    })), [])
  }))
  default     = []
  nullable    = false
}
