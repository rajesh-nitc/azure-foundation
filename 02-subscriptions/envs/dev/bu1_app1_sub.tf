module "bu1_app1_sub" {
  source = "../../modules/base_subscription"
  providers = {
    azurerm = azurerm.sub-bu1-app1-dev
  }

  env      = "dev"
  bu       = "bu1"
  app      = "app1"
  location = "westus"

  # use [web/api]-cicd for workflows or just [web/api] for actual apps 
  uai_roles = {

    # Infra cicd
    "infra-cicd" = [
      "Contributor",
      "Storage Blob Data Contributor", # tfstate
      "Key Vault Secrets Officer",
    ]

    # web cicd
    "web-cicd" = [
      "AcrPush",
      "Managed Identity Operator", # To be able to use uais. web-cicd will use uai web for the container
      "Key Vault Secrets User",
      "Contributor", # Until Azure provide container app admin role
    ]

    # web
    "web" = [
      "AcrPull",

    ]

    # api cicd
    "api-cicd" = [
      "AcrPush",
      "Managed Identity Operator", # To be able to use uais. api-cicd will use uai api for the container
      "Key Vault Secrets User",
      "Contributor", # Until Azure provide container app admin role
    ]

    # api
    "api" = [
      "AcrPull",

    ]
  }

  # In real world, repos will be different
  # repos must exist before running this code

  # Keys must match with the uai_roles (without the cicd suffix)
  # github secret for acr name and rg name will be created
  # github secret for app uai id - which will be used by [web/api]-cicd workflow to assign it to container app
  uai_repos = {
    "infra" = "rajesh-nitc/iac-azure-foundation"
    "web"   = "rajesh-nitc/iac-azure-foundation"
    "api"   = "rajesh-nitc/iac-azure-foundation"
  }

  # Group will be created and role assignments are given to group at subscription level
  # Must have a key named azure-devs
  group_roles = {
    "azure-devs" = [
      "Contributor",
      "Key Vault Secrets Officer",
    ]
    "azure-admins" = [
      "Contributor",
      "Key Vault Secrets Officer",
    ]
  }

  budget_amount = 500
  budget_contact_emails = [
    "rajesh.nitc@gmail.com"
  ]

}

