variable "env" {
  description = "Environment prefix used in the generated Cognitive Account name (must match ^[A-Z][0-9a-z][A-Z][0-9a-z]$ per the module's own validation)"
  type        = string
  default     = "LvTs"
}

variable "group" {
  description = "Business/organizational group identifier used in the generated Cognitive Account name"
  type        = string
  default     = "ECT"
}

variable "project" {
  description = "Short project identifier used in the generated Cognitive Account name"
  type        = string
  default     = "livetest"
}

variable "location" {
  description = "Location for the throwaway live-test resource group"
  type        = string
  default     = "canadacentral"
}

variable "tags" {
  description = "Tags applied to the Cognitive Account created by this harness"
  type        = map(string)
  default = {
    purpose = "module-live-test"
  }
}

variable "pr_number" {
  description = <<-EOT
    Suffix applied to test_dependencies.tf resource names so concurrent PRs
    against this module never collide on the same sandbox subscription. CI
    sources this from `TF_VAR_pr_number` (`github.event.number`); manual runs
    can leave the default or pass their own value.
  EOT
  type        = string
  default     = "manual"
}

variable "cognitive_account" {
  description = "Cognitive account configuration object, passed straight through to the module under test"
  type        = any
}

variable "repository" {
  description = "This repo's own org/name slug - tags the live-test resource group so the shared-subscription sweeper only ever matches this repo's own PRs"
  type        = string
  default     = "canada-ca-terraform-modules/terraform-azurerm-cognitive-account-caf"
}
