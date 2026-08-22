# config/cognitive_account.tfvars
# Tracked, ready-to-run fixture for the test/live harness - one representative
# real-usage instance, not a two-code-path engineered fixture and not a
# dormant "_" template.
#
# Mirrors the module's most common usage: an OpenAI-kind account with system
# assigned identity and a Deny-default network ACL allow-listing one CIDR.
#
# Maintained by whoever adds a new optional input to the module: update this
# file in the same PR if you want live coverage of it, same discipline as
# updating tests/cognitive_account.tftest.hcl.

cognitive_account = {
  sku_name = "S0"
  kind     = "OpenAI"

  # required alongside network_acls by the provider (must be globally unique)
  custom_subdomain_name = "livetest-cognitive-account-caf"

  identity = {
    type = "SystemAssigned"
  }

  network_acls = {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = ["203.0.113.0/24"]
  }
}
