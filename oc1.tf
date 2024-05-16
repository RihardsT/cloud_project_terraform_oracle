resource "oci_core_instance" "oc1" {
  availability_domain = data.oci_identity_availability_domain.rihtest.name # "Xwvt:EU-STOCKHOLM-1-AD-1"
  compartment_id      = oci_identity_compartment.rihtest.id
  shape               = "VM.Standard.A1.Flex"
  display_name        = "oc1"

  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
  }
  create_vnic_details {
    assign_public_ip = "true"
    subnet_id        = oci_core_subnet.test_subnet.id
  }
  source_details {
    boot_volume_size_in_gbs = "100"
    boot_volume_vpus_per_gb = "10"
    source_id               = "ocid1.image.oc1.eu-stockholm-1.aaaaaaaandggwpmi2rcwh5dyqdwi4vkmloh36623r27wpwk2jh4tc3lrodnq"
    source_type             = "image"
  }
  metadata = var.vm_metadata
  provisioner "local-exec" {
    command    = <<EOT
    if ${var.is_run_remotely}; then exit 0; fi;
    export ANSIBLE_HOST_KEY_CHECKING=False && export ANSIBLE_SSH_RETRIES=5 && \
    ansible-playbook -i ${self.public_ip}, \
    -e node_ip_address=${self.public_ip} \
    -u ubuntu --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
    /home/rihards/Code/cloud_project/cloud_project_ansible/oc1.yml
    EOT
    on_failure = continue
  }
}

output "ip" {
  value = oci_core_instance.oc1.public_ip
}
