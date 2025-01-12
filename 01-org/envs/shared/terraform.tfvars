location            = "westus"
sub_id_management   = "3c624b7d-5bd9-45bb-b1e2-485d05be69c2"
sub_id_connectivity = "9f75fbbf-3b6c-4036-971d-426b55119ad5"

allowed_locations = [
  "westus",
  "eastus"
]

# group will be created and roles will be assigned to group on root mg
group_roles = {
  "azure-org-admins"      = ["Owner", "Storage Blob Data Contributor"]
  "azure-security-admins" = ["Security Admin", "User Access Administrator"]
  "azure-network-admins"  = ["Network Contributor"]
  "azure-org-viewers"     = ["Reader"]
}

log_categories = [
  # "Administrative",  # Logs related to administrative actions like resource creation, deletion, etc.
  # "Security",        # Security-related logs for monitoring access and authentication.
  # "ServiceHealth",   # Logs related to service health and outages.
  # "OperationalLogs", # Logs about the operations of the resource (e.g., failures, warnings).
  "Policy" # Logs related to policy events and compliance.
]

law_solutions = [
  {
    name      = "ContainerInsights"
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  },
]

budget_amount = 250
budget_contact_emails = [
  "rajesh.nitc@gmail.com"
]

enable_diagnostics_at_subscription = [
  "3c624b7d-5bd9-45bb-b1e2-485d05be69c2", # sub_id_management
  "9f75fbbf-3b6c-4036-971d-426b55119ad5"  # sub_id_connectivity
]