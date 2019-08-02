#!/bin/bash
packer build\
 -var "organization_id=${SCW_ORGANIZATION_ID}"\
 -var "api_token=${SCW_ACCESS_KEY}"\
 -var "ssh_key=${HOME}/.ssh/id_rsa"\
 -var="domain_name=MY_DOMAINNAME"\
 scaleway.json