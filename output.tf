output "public_ip" {
  value = "${scaleway_ip.ip.ip}"
  description = "Public IP address for newly created resource"
}