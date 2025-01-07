# resource "github_actions_environment_secret" "apim_key" {
#   repository      = var.repo
#   environment     = var.env
#   secret_name     = "REACT_APP_APIM_KEY"
#   plaintext_value = random_password.apim.result
# }