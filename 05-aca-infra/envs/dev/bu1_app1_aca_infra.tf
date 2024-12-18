module "bu1_app1_aca_infra" {
  source = "../../modules/aca"

  env             = "dev"
  bu              = "bu1"
  app             = "app1"
  location        = "westus"
  publisher_name  = "Budita"
  publisher_email = "rajesh.nitc@gmail.com"
  repo            = "rajesh-nitc/iac-azure-foundation"
}