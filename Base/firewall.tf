# Protocol
# 1 = ICMP
# 6 = TCP
# 17 = UDP
resource "oci_core_security_list" "test_security_list" {
  display_name   = "Public security list"
  compartment_id = oci_identity_compartment.rihtest.id
  vcn_id         = oci_core_vcn.test_vcn.id
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
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
  # TCP ingress rules from Internet
  dynamic "ingress_security_rules" {
    for_each = toset([22, 80, 81, 443, 6443, 10250, 25565])
    iterator = tcp_port
    content {
      protocol    = "6"
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      stateless   = false
      tcp_options {
        max = tcp_port.value
        min = tcp_port.value
      }
    }
  }
  ingress_security_rules {
    protocol    = "17"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    udp_options {
      max = 25565
      min = 25565
    }
  }
  ingress_security_rules { # For NAT instance
    protocol    = "all"
    source      = "10.0.1.0/24" # From private subnet
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  timeouts {}
}
