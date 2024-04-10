### Init
```
terraform init -backend-config=secrets/backend
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


### Import
terraform import oci_core_instance.test_instance "ocid1.instance.oc1.eu-stockholm-1.anqxeljruxqu7kycvallsf72kpoq3swiwa52zayuejlyjfradd3ktpc37eka"