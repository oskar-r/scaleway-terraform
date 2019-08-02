docker run -d \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  -l traefik.backend=portainer \
  -l traefik.frontend.rule=Host:admin.$DOMAINNAME \
  -l traefik.port=9000 \
  -l traefik.docker.network=proxy \
  --network proxy \
  --name portainer \
  portainer/portainer --admin-password='"$PORTAINER_PWD"'
