module "bu1_app1_aca_infra" {
  source = "../../modules/aca"

  env             = "dev"
  bu              = "bu1"
  app             = "app1"
  location        = "westus"
  publisher_name  = "Budita"
  publisher_email = "rajesh.nitc@gmail.com"
  # Update after deploying api via github workflow
  service_url = ""
}