mg_root_id                  = "dfeb6941-abde-47b4-8f0e-f0f2fbb4f470"
default_subscription_id     = "8eba36d1-77ed-4614-9d23-ec86131e8315"
location                    = "westus"
terraform_service_principal = "sp-mg-root-terraform"
terraform_service_principal_roles = [
  "Owner",
  "Storage Blob Data Contributor"
]

