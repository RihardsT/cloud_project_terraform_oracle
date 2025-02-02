resource "oci_identity_compartment" "rihtest" {
  compartment_id = var.root_compartment
  description    = "Rih Test Compartment"
  name           = "rihtest"
}

### Storage bucket
data "oci_objectstorage_namespace" "rihtest" {
  compartment_id = oci_identity_compartment.rihtest.id
}

resource "oci_objectstorage_bucket" "rihtest" {
  compartment_id = oci_identity_compartment.rihtest.id
  name           = var.storage_bucket_name # "rih_storage"
  namespace      = data.oci_objectstorage_namespace.rihtest.namespace
}

### VM Stuff - vcn, subnet, route table
data "oci_identity_availability_domain" "rihtest" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_vcn" "test_vcn" {
  display_name   = "Main VNET"
  compartment_id = oci_identity_compartment.rihtest.id
  cidr_blocks    = ["10.0.0.0/16"]
}

resource "oci_core_subnet" "test_subnet" {
  display_name      = "Public subnet"
  cidr_block        = "10.0.0.0/24"
  compartment_id    = oci_identity_compartment.rihtest.id
  vcn_id            = oci_core_vcn.test_vcn.id
  route_table_id    = oci_core_route_table.test_route_table.id
  security_list_ids = [oci_core_security_list.test_security_list.id]
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = oci_identity_compartment.rihtest.id
  vcn_id         = oci_core_vcn.test_vcn.id
}

resource "oci_core_route_table" "test_route_table" {
  display_name   = "Public route table"
  compartment_id = oci_identity_compartment.rihtest.id
  vcn_id         = oci_core_vcn.test_vcn.id
  route_rules {
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}
