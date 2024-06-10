### Init
```
terraform init -backend-config=secrets/backend -upgrade

terraform taint oci_core_instance.oc1
```

### Pre-requisites
Pre-req variable values:  
https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm  
Going through the doc - you first will have to generate new API key.  
Then it will also output the necessary variable values.  

Or simply:  
Go to My Profile -> API Keys -> Add API Key -> Generate API key pair  
-> Download private key and download public key -> Add  
It will show the values.

Get the OCID of root compartment, to create new compartments under:
https://cloud.oracle.com/identity/compartments

After that can follow Terraform provider documentation:  
https://registry.terraform.io/providers/oracle/oci

### Silly alias (on top of the ones in cloud_project_terraform_hetzner repo)
```
tee -a ~/.bash_aliases <<EOF
  alias oc1_up="terraform -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_oracle/ apply -target=hcloud_server.htz1 -auto-approve"
  alias oc1_down="terraform -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_oracle/ destroy -target=hcloud_server.htz1 -auto-approve"
  alias oc1_ssh="ssh $(terraform -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_oracle/ output -raw ip) -o StrictHostKeyChecking=no -o 'UserKnownHostsFile=/dev/null'"
  alias oc1_ansible="ansible-playbook -i $(terraform -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_oracle/ output -raw ip), \
    -e node_ip_address=$(terraform -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_oracle/ output -raw ip) \
    -u rihards --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
    /home/rihards/Code/cloud_project/cloud_project_ansible/oc1.yml"
EOF
```
