<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 5.0.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_cognitive_account.cognitive_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cognitive_account"></a> [cognitive\_account](#input\_cognitive\_account) | Cognitive account configuration object. | <pre>object({<br/>    # Defaults embedded in the type (not try()) — object-type optional() attributes are<br/>    # coerced to null when omitted by the caller, so a try(local.ca.x, default) fallback<br/>    # never fires; the default must live here to actually apply.<br/>    sku_name                           = optional(string, "S0")<br/>    kind                               = optional(string, "OpenAI")<br/>    custom_subdomain_name              = optional(string)<br/>    public_network_access_enabled      = optional(bool)<br/>    outbound_network_access_restricted = optional(bool)<br/>    dynamic_throttling_enabled         = optional(bool)<br/>    local_auth_enabled                 = optional(bool)<br/>    tags                               = optional(map(string))<br/>    # New in azurerm >= 5.0 (also valid on 4.x; module previously did not expose these)<br/>    fqdns                                       = optional(list(string))<br/>    project_management_enabled                  = optional(bool)<br/>    qna_runtime_endpoint                        = optional(string)<br/>    custom_question_answering_search_service_id = optional(string)<br/>    metrics_advisor_aad_client_id               = optional(string)<br/>    metrics_advisor_aad_tenant_id               = optional(string)<br/>    metrics_advisor_super_user_name             = optional(string)<br/>    metrics_advisor_website_name                = optional(string)<br/>    identity = optional(object({<br/>      type         = string<br/>      identity_ids = optional(list(string))<br/>    }))<br/>    customer_managed_key = optional(object({<br/>      key_vault_key_id   = string<br/>      identity_client_id = optional(string)<br/>    }))<br/>    network_acls = optional(object({<br/>      default_action = string<br/>      bypass         = optional(string)<br/>      ip_rules       = optional(list(string))<br/>      virtual_network_rules = optional(list(object({<br/>        subnet_id                            = string<br/>        ignore_missing_vnet_service_endpoint = optional(bool)<br/>      })))<br/>    }))<br/>    # New in azurerm >= 5.0: agent network injection, only applicable when kind = "AIServices"<br/>    network_injection = optional(object({<br/>      scenario  = string<br/>      subnet_id = string<br/>    }))<br/>    storage_accounts = optional(list(object({<br/>      storage_account_id = string<br/>      identity_client_id = optional(string)<br/>    })))<br/>  })</pre> | n/a | yes |
| <a name="input_custom_question_answering_search_service_key"></a> [custom\_question\_answering\_search\_service\_key](#input\_custom\_question\_answering\_search\_service\_key) | Admin key of the Azure Cognitive Search service backing Custom Question Answering (only relevant when cognitive\_account.kind = "TextAnalytics"). Kept out of the cognitive\_account object so it can be marked sensitive - object-type attributes cannot carry sensitive = true individually. | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment code (e.g., dev, test, prod). | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Business or organizational group identifier used in resource naming. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region for resource deployment. Optional - falls back to var.resource\_group.location when unset. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Short project identifier used in resource naming. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group object containing name and (optional) location. location is required here only when var.location is not supplied. | <pre>object({<br/>    name     = string<br/>    location = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the Cognitive Services Account | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | Free-form suffix/purpose string included in resource names (no spaces). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_subdomain_name"></a> [custom\_subdomain\_name](#output\_custom\_subdomain\_name) | The subdomain name used for Entra ID token-based authentication, required for Private Endpoint attachment |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The base endpoint URL of the Cognitive Account |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Cognitive Account |
| <a name="output_identity"></a> [identity](#output\_identity) | The identity block with principal and tenant IDs |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | Primary access key |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | Secondary access key |
<!-- END_TF_DOCS -->
