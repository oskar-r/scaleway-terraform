terraform {
  required_version = "<= 0.12.3"
}
provider "scaleway" {
  organization = var.org_id
  token        = var.token
  region       = var.region
}

resource "scaleway_ip" "ip" {
}

data "scaleway_image" "my-ubuntu" {
  architecture = "x86_64"
  name         = var.image_name
}

resource "scaleway_server" "my-server" {
  name  = "${var.domain_name}"
  public_ip = "${scaleway_ip.ip.ip}"
  image = "${data.scaleway_image.my-ubuntu.id}"
  type  = "${var.instance_type}"
  tags = [var.domain_name, var.image_name]
  //security_group = "${scaleway_security_group.sg.id}"
  connection {
    type     = "ssh"
    user     = "root"
    host = "${scaleway_ip.ip.ip}"
    private_key = file("${var.private_key}")
  }
  provisioner "local-exec" {
    command = "curl  -X PUT https://api.cloudflare.com/client/v4/zones/${var.cloud_flare_zone}/dns_records/${var.cloud_flare_resource} -H 'X-Auth-Email: ${var.cloud_flare_user}' -H 'X-Auth-Key: ${var.cloud_flare_api_key}' -H 'Content-Type: application/json' -d '{\"type\":\"A\",\"name\":\"*.${var.domain_name}\",\"content\":\"${scaleway_ip.ip.ip}\",\"ttl\":1}'"
  }
  provisioner "file" {
    source      = "docker_scripts"
    destination = "/root"
  }
  provisioner "remote-exec" {
    inline = [
      "adduser ${var.username} --gecos \"First Last,RoomNumber,WorkPhone,HomePhone\" --disabled-password",
      "echo \"${var.username}:${var.user_pwd}\" | chpasswd",
      "usermod -aG docker ${var.username}",
      "cp -axv /root/docker_scripts /home/${var.username}",
      "chown -R ${var.username}:${var.username} /home/${var.username}/docker_scripts",
      "export DEBIAN_FRONTEND=noninteractive",
      "mv /etc/sudoers /etc/sudoers.old",
      "apt-get install -yq apache2-utils sudo",
      //"sed -i -e 's|$${var.username}|${var.username}|g' /home/${var.username}/docker_scripts/provisioning.sh",
      "sed -i -e 's|MY_PASSWORD|${var.user_pwd}|g' /home/${var.username}/docker_scripts/provisioning.sh",
      "chmod 700 /home/${var.username}/docker_scripts/provisioning.sh",
      "export DOMAINNAME=${var.domain_name}",
      "export USER_EMAIL=${var.email}",
      "echo ${var.user_pwd} | sudo -S -E -u ${var.username} /home/${var.username}/docker_scripts/provisioning.sh"
    ]
  }
}


resource "scaleway_security_group" "sg" {
  name        = "my_security_group"
  description = "allow SSH, DNS, HTTP and HTTPS traffic, drop rest"
  inbound_default_policy  = "drop"
  enable_default_security = true
}

resource "scaleway_security_group_rule" "http_accept" {
  security_group = "${scaleway_security_group.sg.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 80
}

resource "scaleway_security_group_rule" "https_accept" {
  security_group = "${scaleway_security_group.sg.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 443
}

resource "scaleway_security_group_rule" "ssh_accept" {
  security_group = "${scaleway_security_group.sg.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 22
}

resource "scaleway_security_group_rule" "dns_accept" {
  security_group = "${scaleway_security_group.sg.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 53
}

resource "scaleway_security_group_rule" "dns_udp_accept" {
  security_group = "${scaleway_security_group.sg.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "UDP"
  port      = 53
}