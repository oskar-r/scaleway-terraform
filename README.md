## Desciption
The following repo contains scripts to build a ubuntu image with docker using packer (https://www.packer.io/intro/) and then provision this image and installation of traefik and portainer with TLS support (trough Let's Enncrypt).
Requirement is an account on scaleway with API access as well as packer and terraformer.
In additionn it will update cloudflare DNS with the IP of your new server given that there exists a *.domanname entry.

### Step 1
```shell
$ export SCW_ORGANIZATION_ID=org_id
$ export SCW_ACCESS_KEY=access_key
```

### Step 2 - Build the base image

Edit the build_packer.sh and insert the domain name (or other name of the image)
```shell
$ ./build_packer.sh 
```

### Step 3 - Download provider
```shell
$ terraform init
```

### Step 4 - Provision the server

```shell
$ terraform apply -auto-approve
```

This will ask for all required vaiables needed  altenatively create the file terraform.tfvars with the following variables
```shell
org_id = ""
token = ""
username=""
domain_name=""
email=""
user_pwd=""
private_key=""
cloud_flare_zone=""
cloud_flare_user=""
cloud_flare_api_key=""
cloud_flare_resource=""
```

To find out the right cloudflare resource query with 
```
curl -X GET https://api.cloudflare.com/client/v4/zones/{ZONE_ID}/dns_records&name=*.domain.xx\
-H "X-Auth-Email:cloud_flare_user"\
-H "X-Auth-Key:cloud_flare_api_key"\
-H "Content-Type: application/json"\
```