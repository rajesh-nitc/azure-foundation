variable "sub_id_management" {
  type     = string
  nullable = false
}

variable "sub_id_connectivity" {
  type     = string
  nullable = false
}

variable "allowed_locations" {
  type     = list(string)
  nullable = false
  default  = ["westus"]
}

variable "location" {
  type     = string
  nullable = false
  default  = "westus"
}

variable "log_categories" {
  type     = list(string)
  nullable = false
}

variable "law_solutions" {
  type = list(object({
    name      = string
    publisher = string,
    product   = string,

  }))

  nullable = false
  default  = []
}

variable "group_roles" {
  type     = map(list(string))
  nullable = false
  default  = {}
}

variable "budget_amount" {
  type     = number
  nullable = false
}

variable "budget_contact_emails" {
  type     = list(string)
  nullable = false
}

variable "enable_diagnostics_at_subscription" {
  type     = list(string)
  nullable = false
}