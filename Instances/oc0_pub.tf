data "oci_core_images" "ubuntu_E2_micro" {
  compartment_id           = oci_identity_compartment.rihtest.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.E2.1.Micro"
  state                    = "AVAILABLE"
}

resource "oci_core_instance" "oc0_pub" {
  count               = var.oc0_tf_pub ? 1 : 0
  availability_domain = data.oci_identity_availability_domain.rihtest.name
  compartment_id      = oci_identity_compartment.rihtest.id
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "oc0_pub"

  shape_config {
    memory_in_gbs = 1
    ocpus         = 1
  }
  create_vnic_details {
    assign_public_ip = "true"
    subnet_id        = oci_core_subnet.subnet.id
  }
  source_details {
    boot_volume_size_in_gbs = "50"
    boot_volume_vpus_per_gb = "10"
    source_id               = data.oci_core_images.ubuntu_E2_micro.images[0].id
    source_type             = "image"
  }
  # metadata = var.vm_metadata
  metadata = { "ssh_authorized_keys" = file("~/.ssh/id_rsa.pub") }
  provisioner "local-exec" {
    command    = <<EOT
    if ${var.is_run_remotely}; then exit 0; fi;
    sleep 30 && \
    export ANSIBLE_HOST_KEY_CHECKING=False && export ANSIBLE_SSH_RETRIES=15 && \
    ansible-playbook -i ${self.public_ip}, \
    -e node_ip_address=${self.public_ip} \
    -u ubuntu --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
    /home/rihards/Code/cloud_project/cloud_project_ansible/oc0_pub.yml
    EOT
    on_failure = continue
  }
}

output "oc0_pub_ip" {
  value = oci_core_instance.oc0_pub[*].public_ip
}
