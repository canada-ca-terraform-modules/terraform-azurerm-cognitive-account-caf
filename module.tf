locals {
  ca = var.cognitive_account
}

resource "azurerm_cognitive_account" "cognitive-account" {
  name                = local.name
  resource_group_name = var.resource_group.name
  location            = try(var.location, var.resource_group.location)
  sku_name            = try(local.ca.sku_name, "S0")
  kind                = try(local.ca.kind, "OpenAI")

  custom_subdomain_name              = try(local.ca.custom_subdomain_name, null)
  public_network_access_enabled      = try(local.ca.public_network_access_enabled, null)
  outbound_network_access_restricted = try(local.ca.outbound_network_access_restricted, null)
  dynamic_throttling_enabled         = try(local.ca.dynamic_throttling_enabled, null)
  local_auth_enabled                 = try(local.ca.local_auth_enabled, null)

  # New in azurerm >= 5.0 (also valid on 4.x; module previously did not expose these)
  fqdns                                        = try(local.ca.fqdns, null)
  project_management_enabled                   = try(local.ca.project_management_enabled, null)
  qna_runtime_endpoint                         = try(local.ca.qna_runtime_endpoint, null)
  custom_question_answering_search_service_id  = try(local.ca.custom_question_answering_search_service_id, null)
  custom_question_answering_search_service_key = try(local.ca.custom_question_answering_search_service_key, null)
  metrics_advisor_aad_client_id                = try(local.ca.metrics_advisor_aad_client_id, null)
  metrics_advisor_aad_tenant_id                = try(local.ca.metrics_advisor_aad_tenant_id, null)
  metrics_advisor_super_user_name              = try(local.ca.metrics_advisor_super_user_name, null)
  metrics_advisor_website_name                 = try(local.ca.metrics_advisor_website_name, null)

  tags = merge(try(local.ca.tags, {}), var.tags)

  dynamic "identity" {
    # Wrap single object in list when present, else empty list
    for_each = local.ca.identity == null ? [] : [local.ca.identity]
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  dynamic "customer_managed_key" {
    for_each = local.ca.customer_managed_key == null ? [] : [local.ca.customer_managed_key]
    content {
      key_vault_key_id   = customer_managed_key.value.key_vault_key_id
      identity_client_id = try(customer_managed_key.value.identity_client_id, null)
    }
  }

  dynamic "network_acls" {
    for_each = local.ca.network_acls == null ? [] : [local.ca.network_acls]
    content {
      default_action = network_acls.value.default_action
      bypass         = try(network_acls.value.bypass, null)
      ip_rules       = try(network_acls.value.ip_rules, null)

      dynamic "virtual_network_rules" {
        for_each = network_acls.value.virtual_network_rules == null ? [] : network_acls.value.virtual_network_rules
        content {
          subnet_id                            = virtual_network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = try(virtual_network_rules.value.ignore_missing_vnet_service_endpoint, null)
        }
      }
    }
  }

  # New in azurerm >= 5.0: agent network injection, only applicable when kind = "AIServices"
  dynamic "network_injection" {
    for_each = local.ca.network_injection == null ? [] : [local.ca.network_injection]
    content {
      scenario  = network_injection.value.scenario
      subnet_id = network_injection.value.subnet_id
    }
  }

  dynamic "storage" {
    # List of storage account association objects
    for_each = local.ca.storage_accounts == null ? [] : local.ca.storage_accounts
    content {
      storage_account_id = storage.value.storage_account_id
      identity_client_id = try(storage.value.identity_client_id, null)
    }
  }
}
