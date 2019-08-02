variable "org_id" {
  type = string
  description = "Org id from scaleway"
}

variable "token" {
  type = string
  description = "API token from scaleway"
}

variable "username" {
  type = string
  description = "Name of user running docker"
}

variable "user_pwd" {
  type = string
  description = "Password for user running docker as well as for traefik dashboard"
}

variable "private_key" {
  type = string
  description = "Path to the private key file"
}

variable "domain_name" {
  type = string
  description = "Domain name to set up on the server"
}

variable "email" {
  type = string
  description = "Email address for Let's encrypt certs"
}

variable "cloud_flare_zone" {
  type = string
  description = "Cloudflare zone"
}

variable "cloud_flare_user" {
  type = string
  description = "Cloudflare user"
}

variable "cloud_flare_resource" {
  type = string
  description = "Cloudflare resource ID to update i.e ID form *.domain_name"
}

variable "cloud_flare_api_key" {
  type = string
  description = "Cloudflare api key"
}

variable "region" {
  type = string
  default = "ams1"
  description = "Region to deploy services in"
}

variable "image_name" {
  type = string
  default = "my-ubuntu"
  description = "Name of image to use for the new server"
}

variable "instance_type" {
  type = string
  default = "DEV1-S"
  description = "Instannce type to use https://api.scaleway.com/instance/v1/zones/nl-ams-1/products/servers"
}