docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /home/${USER}/docker_scripts/traefik.toml:/traefik.toml \
  -v /home/${USER}/docker_scripts/acme.json:/acme.json \
  -p 80:80 \
  -p 443:443 \
  -l traefik.frontend.rule=Host:traefik.$DOMAINNAME \
  -l traefik.port=8080 \
  --network proxy \
  --name traefik \
  traefik:1.7.12-alpine --docker