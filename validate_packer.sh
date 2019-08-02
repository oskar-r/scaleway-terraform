packer validate\
 -var 'organization_id=$SCW_ORGANIZATION_ID'\
 -var 'api_token=$SCW_ACCESS_KEY'\
 -var 'ssh_key=$HOME/.ssh/id_rsa'\
 scaleway.json
