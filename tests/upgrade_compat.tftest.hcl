# Purpose: catch breaking resource changes before dev tests on real infra
# How: run blocks share state — apply creates mock state; next plan runs against it
mock_provider "azurerm" {}

variables {
  env               = "DvPc"
  group             = "ECT"
  project           = "acct"
  userDefinedString = "oai"
  location          = "canadacentral"
  resource_group = {
    name     = "rg-test"
    location = "canadacentral"
  }
}

# Step 1: simulate currently-deployed resource (pre-upgrade inputs, no new args)
run "baseline_apply" {
  command = apply
  variables {
    cognitive_account = {
      sku_name = "S0"
      kind     = "OpenAI"
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive-account.name == "DvPc-ECT-acct-oai-aais"
    error_message = "Baseline apply: unexpected resource name"
  }
}

# Step 2: plan upgraded code against that state — new args added
run "upgrade_plan_no_replacement" {
  command = plan
  variables {
    cognitive_account = {
      sku_name = "S0"
      kind     = "OpenAI"
      fqdns    = ["example.com"]
    }
  }
  assert {
    condition     = azurerm_cognitive_account.cognitive-account.name == "DvPc-ECT-acct-oai-aais"
    error_message = "Resource name must be unchanged after upgrade"
  }
  assert {
    condition     = tolist(azurerm_cognitive_account.cognitive-account.fqdns)[0] == "example.com"
    error_message = "fqdns must be set on upgraded plan"
  }
}
