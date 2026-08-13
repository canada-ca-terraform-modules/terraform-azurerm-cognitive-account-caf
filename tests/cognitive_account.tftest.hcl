mock_provider "azurerm" {}

variables {
  env               = "DvPc"
  group             = "ECT"
  project           = "acct"
  userDefinedString = "oai"
  resource_group = {
    name     = "rg-test"
    location = "canadacentral"
  }
}

run "naming_convention" {
  command = plan
  variables {
    cognitive_account = {
      sku_name = "S0"
      kind     = "OpenAI"
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.name == "DvPc-ECT-acct-oai-aais"
    error_message = "Name must follow {env}-{group}-{project}-{userDefinedString}-aais convention"
  }
}

run "default_values" {
  command = plan
  variables {
    cognitive_account = {}
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.sku_name == "S0"
    error_message = "sku_name must default to S0"
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.kind == "OpenAI"
    error_message = "kind must default to OpenAI"
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.location == "canadacentral"
    error_message = "location must fall back to resource_group.location when var.location is unset"
  }
}

run "location_override" {
  command = plan
  variables {
    location          = "eastus"
    cognitive_account = {}
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.location == "eastus"
    error_message = "var.location must override resource_group.location when explicitly set"
  }
}

run "identity_system_assigned" {
  command = plan
  variables {
    cognitive_account = {
      identity = { type = "SystemAssigned" }
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.identity[0].type == "SystemAssigned"
    error_message = "identity block must be emitted when supplied"
  }
}

run "identity_user_assigned" {
  command = plan
  variables {
    cognitive_account = {
      identity = {
        type         = "UserAssigned"
        identity_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-identities/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-test"]
      }
    }
  }
  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account.identity[0].identity_ids) == 1
    error_message = "identity_ids must be passed through for UserAssigned identity"
  }
}

run "no_identity" {
  command = plan
  variables {
    cognitive_account = {}
  }
  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account.identity) == 0
    error_message = "identity block must not be emitted when omitted"
  }
}

run "customer_managed_key" {
  command = plan
  variables {
    cognitive_account = {
      customer_managed_key = {
        key_vault_key_id = "https://my-kv.vault.azure.net/keys/cmk/00000000000000000000000000000000"
      }
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.customer_managed_key[0].key_vault_key_id == "https://my-kv.vault.azure.net/keys/cmk/00000000000000000000000000000000"
    error_message = "customer_managed_key block must be emitted when supplied"
  }
}

run "network_acls_ip_rules" {
  command = plan
  variables {
    cognitive_account = {
      custom_subdomain_name = "mycogacctsubdomain"
      network_acls = {
        default_action = "Deny"
        ip_rules       = ["203.0.113.10"]
      }
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.network_acls[0].default_action == "Deny"
    error_message = "network_acls.default_action must be passed through"
  }
  assert {
    condition     = tolist(azurerm_cognitive_account.cognitive_account.network_acls[0].ip_rules)[0] == "203.0.113.10"
    error_message = "network_acls.ip_rules must be passed through"
  }
}

run "network_acls_bypass" {
  command = plan
  variables {
    cognitive_account = {
      custom_subdomain_name = "mycogacctsubdomain"
      network_acls = {
        default_action = "Deny"
        bypass         = "AzureServices"
      }
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.network_acls[0].bypass == "AzureServices"
    error_message = "network_acls.bypass must be passed through"
  }
}

run "network_acls_virtual_network_rules" {
  command = plan
  variables {
    cognitive_account = {
      custom_subdomain_name = "mycogacctsubdomain"
      network_acls = {
        default_action = "Deny"
        virtual_network_rules = [
          {
            subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/snet-ai"
            ignore_missing_vnet_service_endpoint = true
          }
        ]
      }
    }
  }
  assert {
    condition     = tolist(azurerm_cognitive_account.cognitive_account.network_acls[0].virtual_network_rules)[0].subnet_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/snet-ai"
    error_message = "virtual_network_rules.subnet_id must be passed through"
  }
  assert {
    condition     = tolist(azurerm_cognitive_account.cognitive_account.network_acls[0].virtual_network_rules)[0].ignore_missing_vnet_service_endpoint == true
    error_message = "virtual_network_rules.ignore_missing_vnet_service_endpoint must be passed through"
  }
}

run "storage_accounts" {
  command = plan
  variables {
    cognitive_account = {
      storage_accounts = [
        { storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-storage/providers/Microsoft.Storage/storageAccounts/staiacct001" }
      ]
    }
  }
  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account.storage) == 1
    error_message = "storage block must be emitted for each storage_accounts entry"
  }
}

run "network_injection" {
  command = plan
  variables {
    cognitive_account = {
      kind = "AIServices"
      network_injection = {
        scenario  = "agent"
        subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/snet-agent"
      }
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.network_injection[0].scenario == "agent"
    error_message = "network_injection block must be emitted when supplied"
  }
}

run "no_network_injection" {
  command = plan
  variables {
    cognitive_account = {}
  }
  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account.network_injection) == 0
    error_message = "network_injection block must not be emitted when omitted"
  }
}

run "fqdns" {
  command = plan
  variables {
    cognitive_account = {
      fqdns = ["example.com"]
    }
  }
  assert {
    condition     = tolist(azurerm_cognitive_account.cognitive_account.fqdns)[0] == "example.com"
    error_message = "fqdns must be passed through"
  }
}

run "project_management_enabled" {
  command = plan
  variables {
    cognitive_account = {
      kind                       = "AIServices"
      project_management_enabled = true
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.project_management_enabled == true
    error_message = "project_management_enabled must be passed through"
  }
}

run "qna_runtime_endpoint" {
  command = plan
  variables {
    cognitive_account = {
      kind                 = "QnAMaker"
      qna_runtime_endpoint = "https://my-qna-runtime.azurewebsites.net"
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.qna_runtime_endpoint == "https://my-qna-runtime.azurewebsites.net"
    error_message = "qna_runtime_endpoint must be passed through"
  }
}

run "custom_question_answering" {
  command = plan
  variables {
    custom_question_answering_search_service_key = "search-service-admin-key"
    cognitive_account = {
      kind                                        = "TextAnalytics"
      custom_question_answering_search_service_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-search/providers/Microsoft.Search/searchServices/search-svc"
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.custom_question_answering_search_service_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-search/providers/Microsoft.Search/searchServices/search-svc"
    error_message = "custom_question_answering_search_service_id must be passed through"
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.custom_question_answering_search_service_key == "search-service-admin-key"
    error_message = "custom_question_answering_search_service_key must be passed through"
  }
}

run "metrics_advisor_arguments" {
  command = plan
  variables {
    cognitive_account = {
      kind                            = "MetricsAdvisor"
      metrics_advisor_aad_client_id   = "33333333-3333-3333-3333-333333333333"
      metrics_advisor_aad_tenant_id   = "44444444-4444-4444-4444-444444444444"
      metrics_advisor_super_user_name = "admin@example.org"
      metrics_advisor_website_name    = "my-metrics-advisor-site"
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.metrics_advisor_aad_client_id == "33333333-3333-3333-3333-333333333333"
    error_message = "metrics_advisor_aad_client_id must be passed through"
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.metrics_advisor_aad_tenant_id == "44444444-4444-4444-4444-444444444444"
    error_message = "metrics_advisor_aad_tenant_id must be passed through"
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.metrics_advisor_super_user_name == "admin@example.org"
    error_message = "metrics_advisor_super_user_name must be passed through"
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.metrics_advisor_website_name == "my-metrics-advisor-site"
    error_message = "metrics_advisor_website_name must be passed through"
  }
}

run "custom_tags_merge" {
  command = plan
  variables {
    cognitive_account = {
      tags = { Owner = "team-a" }
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.tags["Owner"] == "team-a"
    error_message = "cognitive_account.tags must be merged into resource tags"
  }
}

run "dynamic_throttling_enabled" {
  command = plan
  variables {
    cognitive_account = {
      kind                       = "CognitiveServices"
      dynamic_throttling_enabled = true
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive_account.dynamic_throttling_enabled == true
    error_message = "dynamic_throttling_enabled must be passed through for a kind that supports it"
  }
}

# --- kind-specific precondition guards (lifecycle.precondition in module.tf) ---

run "network_injection_wrong_kind" {
  command = plan
  variables {
    cognitive_account = {
      kind = "OpenAI"
      network_injection = {
        scenario  = "agent"
        subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-main/subnets/snet-agent"
      }
    }
  }
  expect_failures = [
    azurerm_cognitive_account.cognitive_account,
  ]
}

run "project_management_enabled_wrong_kind" {
  command = plan
  variables {
    cognitive_account = {
      kind                       = "OpenAI"
      project_management_enabled = true
    }
  }
  expect_failures = [
    azurerm_cognitive_account.cognitive_account,
  ]
}

run "dynamic_throttling_enabled_wrong_kind" {
  command = plan
  variables {
    cognitive_account = {
      kind                       = "OpenAI"
      dynamic_throttling_enabled = true
    }
  }
  expect_failures = [
    azurerm_cognitive_account.cognitive_account,
  ]
}

run "qna_runtime_endpoint_wrong_kind" {
  command = plan
  variables {
    cognitive_account = {
      kind                 = "OpenAI"
      qna_runtime_endpoint = "https://my-qna-runtime.azurewebsites.net"
    }
  }
  expect_failures = [
    azurerm_cognitive_account.cognitive_account,
  ]
}

run "metrics_advisor_wrong_kind" {
  command = plan
  variables {
    cognitive_account = {
      kind                         = "OpenAI"
      metrics_advisor_website_name = "my-metrics-advisor-site"
    }
  }
  expect_failures = [
    azurerm_cognitive_account.cognitive_account,
  ]
}
