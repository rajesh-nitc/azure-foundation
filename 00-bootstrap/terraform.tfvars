default_subscription_id     = "8eba36d1-77ed-4614-9d23-ec86131e8315"
location                    = "westus"
terraform_service_principal = "sp-terraform-foundation"
terraform_service_principal_roles = [
  "Owner",
  "Storage Blob Data Contributor",
]
