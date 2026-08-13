###############################################
# cognitiveAccount.tfvars
# Values + commented examples for optional fields
# Adjust placeholders (subscription IDs, resource names, locations) as needed.
###############################################

# Required naming/context variables (usually passed by L0/L1 via Terragrunt root.hcl)
# env               = "G3Dc"          # Must match pattern Upper-lower-Upper-lower per validation
# group             = "ABC"          # Alphanumeric only
# project           = "Portal"        # Alphanumeric only
# userDefinedString = "Project123"     # Alphanumeric only

# # Resource group object (expected: name & location)
# resource_group = {
#     name     = "rg-apps-portal-devp"
#     location = "canadacentral"
# }

# Cognitive account configuration
cognitive_account = {
  # OPTIONAL simple attributes (uncomment & set as needed)
  # sku_name                      = "S0"                 # Common SKU (e.g., F0, S0)
  # kind                          = "CognitiveServices"  # e.g., CognitiveServices, OpenAI
  # custom_subdomain_name         = "mycogacctsubdomain"  # Must be globally unique if used
  # public_network_access_enabled = true                  # true/false
  # outbound_network_access_restricted = true            # true to restrict outbound
  # dynamic_throttling_enabled    = false
  # local_auth_enabled            = false                # Disable local auth for stricter security

  # tags = {                                                # Optional tags map
  #   Environment = "dev"
  #   Owner        = "team@example.org"
  # }

  # identity = {                                             # Identity block (optional)
  #   type = "SystemAssigned"                                # SystemAssigned | UserAssigned | SystemAssigned,UserAssigned
  #   # identity_ids = [                                     # Required if type includes UserAssigned
  #   #   "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-identities/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uaid-example"
  #   # ]
  # }

  # customer_managed_key = {                                 # Customer managed key (optional)
  #   key_vault_key_id   = "https://my-key-vault.vault.azure.net/keys/cmk-key/00000000000000000000000000000000"
  #   # identity_client_id = "11111111-1111-1111-1111-111111111111" # If using a user-assigned identity
  # }

  # network_acls = {                                         # Network ACLs (optional)
  #   default_action = "Deny"                                # Allow | Deny
  #   # bypass = "AzureServices"                              # None | AzureServices (only when kind = OpenAI, AIServices, or TextAnalytics)
  #   # ip_rules = ["203.0.113.10", "198.51.100.25"]        # Public IPs
  #   # virtual_network_rules = [                            # Subnets with service endpoints
  #   #   { subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/snet-ai"
  #   #     ignore_missing_vnet_service_endpoint = false }
  #   # ]
  # }

  # network_injection = {                                    # Agent network injection (optional, only when kind = "AIServices")
  #   scenario  = "agent"
  #   subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/snet-agent"
  # }

  # storage_accounts = [                                     # List of storage accounts (optional)
  #   {
  #     storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-storage/providers/Microsoft.Storage/storageAccounts/staiacct001"
  #     # identity_client_id = "22222222-2222-2222-2222-222222222222" # If needed for access
  #   }
  # ]

  # New in azurerm >= 5.0 (also valid on 4.x; module previously did not expose these)
  # fqdns                             = ["example.com"]      # List of FQDNs allowed for the Cognitive Account
  # project_management_enabled        = true                 # Only valid when kind = "AIServices"
  # qna_runtime_endpoint              = "https://my-qna-runtime.azurewebsites.net" # Legacy QnA Maker endpoint
  # custom_question_answering_search_service_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-search/providers/Microsoft.Search/searchServices/search-svc" # Only when kind = TextAnalytics
  # custom_question_answering_search_service_key = "search-service-admin-key"                                                                                                          # Only when kind = TextAnalytics
  # metrics_advisor_aad_client_id     = "33333333-3333-3333-3333-333333333333" # Only when kind = MetricsAdvisor
  # metrics_advisor_aad_tenant_id     = "44444444-4444-4444-4444-444444444444" # Only when kind = MetricsAdvisor
  # metrics_advisor_super_user_name   = "admin@example.org"                    # Only when kind = MetricsAdvisor
  # metrics_advisor_website_name      = "my-metrics-advisor-site"              # Only when kind = MetricsAdvisor
}

###############################################
# Activate attributes by uncommenting and customizing.
###############################################
