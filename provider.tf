variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
  backend "http" {}
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Variables for resources
variable "root_compartment" {}
variable "vm_metadata" {}
variable "vm_metadata_pub_rsa" {}
variable "internal_vm_metadata" {}

variable "storage_bucket_name" { default = "rih_storage" }
variable "is_run_remotely" { default = true }

variable "oc1_tf" { default = false }
variable "oc0_tf" { default = false }
variable "oc0_tf_pub" { default = false }
