### Init
```
tofu init -backend-config=secrets/backend -upgrade

# With my trashy tfer
tfer init -backend-config=../secrets/backend -upgrade

# Checking the API calls?
TF_LOG=DEBUG TF_LOG_PROVIDER=DEBUG tfer apply -auto-approve
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
# Set up secrets
mkdir ~/.oci
vi ~/.oci/config
vi ~/.oci/oci_api_key.pem

cd cloud_project/cloud_project_terraform_oracle
mkdir secrets
# Put in backend
vi secrets/backend
vi terraform.tfvars

tofu init -backend-config=secrets/backend -upgrade
../tfer/tfer plan
```
