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
