docker network create proxy
docker volume create portainer_data
htpasswd -nb admin MY_PASSWORD > /home/${USER}/tmp.txt
export TRAEFIK_PWD=$(cat /home/${USER}/tmp.txt)
htpasswd -nb -B admin MY_PASSWORD > /home/${USER}/tmp.txt
export PORTAINER_PWD=$(cat /home/${USER}/tmp.txt | cut -d ":" -f 2)
sed -i -e 's|admin:secure_pwd|'"$TRAEFIK_PWD"'|g' /home/${USER}/docker_scripts/traefik.toml
sed -i -e 's|domainname|'"$DOMAINNAME"'|g' /home/${USER}/docker_scripts/traefik.toml
sed -i -e 's|my_email|'"$USER_EMAIL"'|g' /home/${USER}/docker_scripts/traefik.toml
chmod 700 /home/${USER}/docker_scripts/*.sh
chmod 600 /home/${USER}/docker_scripts/acme.json
/home/${USER}/docker_scripts/run_traefik.sh
/home/${USER}/docker_scripts/run_portainer.sh