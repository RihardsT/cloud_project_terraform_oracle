# data "oci_core_images" "example_images" {
#   compartment_id = oci_identity_compartment.rihtest.id
#   operating_system        = "Oracle Linux"
#   operating_system_version = "7.9"
#   shape                   = "VM.Standard.E2.1.Micro"
#   state                   = "AVAILABLE"
# }
# # output "image_id" {
# #   value = data.oci_core_images.example_images.images[0].id
# # }

# resource "oci_core_instance" "oc0" {
#   availability_domain = data.oci_identity_availability_domain.rihtest.name # "Xwvt:EU-STOCKHOLM-1-AD-1"
#   compartment_id      = oci_identity_compartment.rihtest.id
#   shape               = "VM.Standard.E2.1.Micro"
#   display_name        = "oc0"

#   shape_config {
#     memory_in_gbs = 1
#     ocpus         = 1
#   }
#   create_vnic_details {
#     assign_public_ip = "true"
#     subnet_id        = oci_core_subnet.test_subnet.id
#   }
#   source_details {
#     boot_volume_size_in_gbs = "50"
#     boot_volume_vpus_per_gb = "10"
#     # source_id               = "ocid1.image.oc1.eu-stockholm-1.aaaaaaaandggwpmi2rcwh5dyqdwi4vkmloh36623r27wpwk2jh4tc3lrodnq"
#     source_id               = data.oci_core_images.example_images.images[0].id
#     source_type             = "image"
#   }
#   metadata = var.vm_metadata
#   # provisioner "local-exec" {
#   #   command    = <<EOT
#   #   if ${var.is_run_remotely}; then exit 0; fi;
#   #   export ANSIBLE_HOST_KEY_CHECKING=False && export ANSIBLE_SSH_RETRIES=5 && \
#   #   ansible-playbook -i ${self.public_ip}, \
#   #   -e node_ip_address=${self.public_ip} \
#   #   -u ubuntu --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
#   #   /home/rihards/Code/cloud_project/cloud_project_ansible/oc1.yml
#   #   EOT
#   #   on_failure = continue
#   # }
# }

# output "ip_0" {
#   value = oci_core_instance.oc0.public_ip
# }
