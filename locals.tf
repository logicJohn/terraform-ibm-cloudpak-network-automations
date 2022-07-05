
locals {
  namespace              = "cp4na"
  entitled_registry      = "cp.icr.io"
  entitled_registry_user = "cp"
  docker_registry        = "cp.icr.io" // Staging: "cp.stg.icr.io/cp/cpd"
  docker_username        = "cp"        // "ekey"
  entitled_registry_key  = chomp(var.entitled_registry_key)

  openshift_version_regex  = regex("(\\d+).(\\d+)(.\\d+)*(_openshift)*", var.openshift_version)
  openshift_version_number = local.openshift_version_regex[3] == "_openshift" ? tonumber("${local.openshift_version_regex[0]}.${local.openshift_version_regex[1]}") : 0

}
