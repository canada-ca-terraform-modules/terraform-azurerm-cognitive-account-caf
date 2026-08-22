# test_dependencies.tf
# Self-contained dependency resources, owned entirely by this harness.
#
# Deliberately NOT reusing any shared/production resource group: writing into
# a shared RG usually requires elevated, non-sandbox permissions. A dedicated
# throwaway RG here needs only Contributor on the sandbox subscription and
# can never collide with or affect any production resource.
#
# terraform-azurerm-cognitive-account-caf does not require any parent
# resource beyond a resource group (network_acls.virtual_network_rules and
# network_injection are left unset in the tracked fixture) - no vnet
# dependency is created here.

resource "azurerm_resource_group" "live_test" {
  # PR-number suffix keeps two concurrently open PRs against this module from
  # colliding on the same sandbox resource group.
  name     = "${var.env}-cognitive-account-caf-live-test-${var.pr_number}-rg"
  location = var.location

  # pr-number tag (ticket 13): lets the nightly orphan sweeper find this RG
  # by tag and match it back to a PR, independent of naming convention.
  # repository tag: the sandbox subscription is shared across module repos
  # (ticket 03), so the sweeper must scope its `pr-number` matches to only
  # this repo's own PRs - otherwise a PR number collision across repos could
  # misclassify (or destroy) another repo's live resource group.
  tags = {
    "pr-number"  = var.pr_number
    "repository" = var.repository
  }
}

locals {
  # terraform-azurerm-cognitive-account-caf expects resource_group.{name,location}.
  resource_group = {
    name     = azurerm_resource_group.live_test.name
    location = azurerm_resource_group.live_test.location
  }
}
