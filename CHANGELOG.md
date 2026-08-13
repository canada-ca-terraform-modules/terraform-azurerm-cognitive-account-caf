# Changelog

All notable changes to this module are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## v2.0.0 - 2026-08-13

### Added

- `providers.tf` pinning `azurerm ~> 5.0`, `required_version >= 1.9` (module previously had no explicit provider/version constraints).
- `.tflint.hcl` (`call_module_type = "local"`) and `.github/workflows/terraform-ci.yml` running `fmt`, `init`, `validate`, `test`, `tflint`.
- `.github/workflows/release.yml` — creates a GitHub release on merge to `main`, tagged with the version pinned in `ESLZ/cognitiveAccount.tf`'s `?ref=`.
- `.gitignore` and `.gitattributes` (LF enforcement).
- `tests/cognitive_account.tftest.hcl` (21 runs) and `tests/upgrade_compat.tftest.hcl` (state-chaining upgrade safety test).
- New `azurerm_cognitive_account` arguments exposed on `cognitive_account` (all optional, `try(..., null)`-gated, no compat break):
  - `fqdns`
  - `project_management_enabled`
  - `qna_runtime_endpoint`
  - `custom_question_answering_search_service_id` / `custom_question_answering_search_service_key`
  - `metrics_advisor_aad_client_id` / `metrics_advisor_aad_tenant_id` / `metrics_advisor_super_user_name` / `metrics_advisor_website_name`
  - `network_acls.bypass`
  - `network_acls.virtual_network_rules[].ignore_missing_vnet_service_endpoint`
  - `network_injection` block (`scenario`, `subnet_id`) — only applicable when `kind = "AIServices"`

### Changed

- Bumped `ESLZ/cognitiveAccount.tf` module `ref` from `v1.0.0` to `v2.0.0` (major bump: this upgrade adds `providers.tf`/`required_version` where none previously existed, which is a new hard constraint for existing callers).
- `.github/workflows/documentation.yaml` action pins bumped: `actions/checkout` `v4.1.7` -> `v7.0.1`, `terraform-docs/gh-actions` `v1.2.0` -> `v1.4.1`.

### Notes

- `azurerm_cognitive_account` resource schema for every argument this module already exposed is unchanged between azurerm `~>4.0` and `5.0.1` — this upgrade is purely additive (new optional args) plus housekeeping (provider pin, CI, tests). No bugs found, no `moved` blocks required, no naming-convention changes.
- A prior `recall.py` lesson (dated 2026-08-11) claimed this exact module was already upgraded to azurerm 5.0.1 with these same artifacts. That claim did not match the actual repository state (no `providers.tf`, `tests/`, `CHANGELOG.md`, or CI workflows were present in `git log`/on disk before this upgrade) and was treated as an unverified prior-session note, not ground truth.
