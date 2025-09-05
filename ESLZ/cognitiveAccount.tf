resource "azurerm_resource_group" "main" {
  name     = "example"
  location = "canadaeast"
}

module "openai" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-cognitive-account-caf.git?ref=v1.0.0"
  
  env               = "G3Pc"          # Must match pattern Upper-lower-Upper-lower per validation
  group             = "ECT"          # Alphanumeric only
  project           = "account"        # Alphanumeric only
  userDefinedString = "oai"     # Alphanumeric only

  # Resource group object (expected: name & location)
  resource_group = azurerm_resource_group.main

  # Cognitive account configuration
  cognitive_account = {
    sku_name = "S0"                 # Common SKU (e.g., F0, S0)
    kind     = "OpenAI"  # e.g., CognitiveServices, OpenAI
  }
}