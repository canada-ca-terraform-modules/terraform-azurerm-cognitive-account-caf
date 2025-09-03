<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_cognitive_account.cognitive-account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cognitive_account"></a> [cognitive\_account](#input\_cognitive\_account) | Cognitive account configuration object. | <pre>object({<br>        sku_name                          = optional(string)<br>        kind                              = optional(string)<br>        custom_subdomain_name             = optional(string)<br>        public_network_access_enabled     = optional(bool)<br>        outbound_network_access_restricted = optional(bool)<br>        dynamic_throttling_enabled        = optional(bool)<br>        local_auth_enabled                = optional(bool)<br>        tags                              = optional(map(string))<br>        identity = optional(object({<br>            type         = string<br>            identity_ids = optional(list(string))<br>        }))<br>        customer_managed_key = optional(object({<br>            key_vault_key_id   = string<br>            identity_client_id = optional(string)<br>        }))<br>        network_acls = optional(object({<br>            default_action        = string<br>            ip_rules              = optional(list(string))<br>            virtual_network_rules = optional(list(object({ subnet_id = string })))<br>        }))<br>        storage_accounts = optional(list(object({<br>            storage_account_id = string<br>            identity_client_id = optional(string)<br>        })))<br>    })</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment code (e.g., dev, test, prod). | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Business or organizational group identifier used in resource naming. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Short project identifier used in resource naming. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group object containing name and location. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the function app | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | Free-form suffix/purpose string included in resource names (no spaces). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The base endpoint URL of the Cognitive Account |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Cognitive Account |
| <a name="output_identity"></a> [identity](#output\_identity) | The identity block with principal and tenant IDs |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | Primary access key |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | Secondary access key |
<!-- END_TF_DOCS -->
