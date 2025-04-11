### Init
```
tofu init -backend-config=secrets/backend -upgrade

# With my trashy tfer
tfer init -backend-config=../secrets/backend -upgrade
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


### Running in Oracle Cloud shell
With cloud_project repo cloned and tfer repo too.
```
cd cloud_project/cloud_project_terraform_oracle
../tfer/tfer plan
```
