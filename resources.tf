resource "oci_identity_compartment" "test_compartment" {
  compartment_id = var.root_compartment
  description    = "Rih Test Compartment"
  name           = "rihtest"
}

data "oci_objectstorage_namespace" "test_namespace" {
  compartment_id = oci_identity_compartment.test_compartment.id
}

resource "oci_objectstorage_bucket" "test_bucket" {
  compartment_id = oci_identity_compartment.test_compartment.id
  # compartment_id = var.root_compartment
  name      = "rih_test_storage"
  namespace = data.oci_objectstorage_namespace.test_namespace.namespace
}

data "oci_identity_availability_domain" "test_compartment" {
    compartment_id = var.tenancy_ocid
    ad_number = 1
}

# resource "oci_core_instance" "test_instance" {
#   availability_domain = data.oci_identity_availability_domain.test_compartment.name # "Xwvt:EU-STOCKHOLM-1-AD-1"
#   compartment_id = oci_identity_compartment.test_compartment.id
#   shape = "VM.Standard.A1.Flex"
#   display_name = "oc1"

#   shape_config {
#     memory_in_gbs = 24
#     ocpus = 4
#   }
#   source_details {
#     boot_volume_size_in_gbs = "100"
#     boot_volume_vpus_per_gb = "10"
#     source_id               = "ocid1.image.oc1.eu-stockholm-1.aaaaaaaandggwpmi2rcwh5dyqdwi4vkmloh36623r27wpwk2jh4tc3lrodnq"
#     source_type             = "image"
#     # instance_source_image_filter_details {
#     #   compartment_id = oci_identity_compartment.test_compartment.id
#     #   operating_system = "Canonical Ubuntu"
#     #   operating_system_version = "22.04"
#     # }
#   }
#   metadata = {
#     "ssh_authorized_keys" = "PUBLIC_KEY_HERE"
#   }
# }
