variable "enable" {
  default     = true
  description = "If set to true installs Cloud-Pak for NetworkAutomation on the given cluster"
}

variable "force" {
  default     = false
  description = "Force the execution. Useful to execute the job again"
}

variable "cluster_config_path" {
  default     = "./.kube/config/"
  description = "Path to the Kubernetes configuration file to access your cluster"
}

variable "openshift_version" {
  default     = "4.7"
  description = "Openshift version installed in the cluster"
}

variable "on_vpc" {
  default     = false
  type        = bool
  description = "If set to true, lets the module know cluster is using VPC Gen2"
}

variable "portworx_is_ready" {
  type    = any
  default = null
}

variable "entitled_registry_key" {
  description = "Get the entitlement key from https://myibm.ibm.com/products-services/containerlibrary"
}

variable "entitled_registry_user_email" {
  description = "Docker email address"
}

variable "namespace" {
  default     = "cp4na"
  description = "Namespace for Cloud Pak for Network Automation"
}

