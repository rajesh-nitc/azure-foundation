variable "env" {
  type     = string
  nullable = false
}

variable "bu" {
  type     = string
  nullable = false
}

variable "app" {
  type     = string
  nullable = false
}

variable "location" {
  type     = string
  nullable = false
  default  = "westus"
}

variable "uai_roles" {
  type     = map(list(string))
  nullable = false
  default  = {}
  validation {
    condition     = contains(keys(var.uai_roles), "infra-cicd")
    error_message = "Must have a key named infra-cicd"
  }
}

variable "uai_repos" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "group_roles" {
  type     = map(list(string))
  nullable = false
  default  = {}
  validation {
    condition     = contains(keys(var.group_roles), "azure-devs")
    error_message = "Must have a key named azure-devs"
  }
}

variable "budget_amount" {
  type     = number
  nullable = false
}

variable "budget_contact_emails" {
  type     = list(string)
  nullable = false
}

variable "github_owner" {
  type     = string
  nullable = false
}
