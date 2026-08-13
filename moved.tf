# moved.tf
# Renamed the resource label from the hyphenated "cognitive-account" to the
# idiomatic "cognitive_account" (Terraform style guide prefers underscores).
# No consumers are on v2.0.0 yet, but this harness's own upgrade-probe
# baseline (v1.0.0) already deployed real state under the old label - this
# moved block keeps that (and any other early adopter) from seeing a
# destroy+recreate purely due to the rename.
moved {
  from = azurerm_cognitive_account.cognitive-account
  to   = azurerm_cognitive_account.cognitive_account
}
