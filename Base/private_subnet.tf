##### Make sure that main instance has ip forward and iptables set
# sudo sysctl -w net.ipv4.ip_forward=1
# sudo iptables -t nat -A POSTROUTING -o enp0s6 -j MASQUERADE
# sudo iptables -t filter -A FORWARD -o enp0s6 -j ACCEPT

### Private subnet configuration, to enable oc1 instance to work as NAT instance
resource "oci_core_security_list" "private_security_list" {
  display_name   = "Private security list"
  compartment_id = oci_identity_compartment.rihtest.id
  vcn_id         = oci_core_vcn.vcn.id
  egress_security_rules {
    protocol         = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    stateless        = false
  }

  ingress_security_rules {
    protocol    = "all"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  ingress_security_rules {
    protocol    = "1"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      code = -1
      type = 3
    }
  }
  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      code = 4
      type = 3
    }
  }

  timeouts {}
}

data "oci_core_vnic_attachments" "oc1_vnic" {
  count               = var.oc1_tf ? 1 : 0
  compartment_id = oci_identity_compartment.rihtest.id
  instance_id    = oci_core_instance.oc1[0].id
}
data "oci_core_private_ips" "private_ips_by_ip_address" {
  count               = var.oc1_tf ? 1 : 0
  vnic_id = data.oci_core_vnic_attachments.oc1_vnic[0].vnic_attachments[0].vnic_id
}
# output "vnic" {
#   value = data.oci_core_private_ips.private_ips_by_ip_address.private_ips[0].id
# }

resource "oci_core_route_table" "private_route_table" {
  count               = var.oc1_tf ? 1 : 0
  display_name   = "Private route table"
  compartment_id = oci_identity_compartment.rihtest.id
  vcn_id         = oci_core_vcn.vcn.id
  route_rules {
    network_entity_id = data.oci_core_private_ips.private_ips_by_ip_address[0].private_ips[0].id # oc1 instance private ip
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "private_subnet" {
  count               = var.oc1_tf ? 1 : 0
  display_name              = "Private subnet"
  cidr_block                = "10.0.1.0/24"
  compartment_id            = oci_identity_compartment.rihtest.id
  vcn_id                    = oci_core_vcn.vcn.id
  route_table_id            = oci_core_route_table.private_route_table[0].id
  security_list_ids         = [oci_core_security_list.private_security_list.id]
  prohibit_internet_ingress = true
}
