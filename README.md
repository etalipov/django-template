# Template for Django app with CI-CD on VPS

## Add to the repository secrets:
* `SSH_LOGIN` - username on VPS server
* `SSH_HOST` - VPS server IP
* `SSH_KEY` - privat ssh key for ssh connect on VPS
* `ENV_FILE` - exemple in `.env.template`
* `GHCR_TOKEN` - token for access github regestry

## Setup VPS on Debian linux:

### 1. OS setup:
* connect to VPS `ssh root@vps_server_ip`
* `apt update && apt upgrade -y`
* `adduser my_cool_user`
* `usermod -aG sudo my_cool_user`

* add in `/etc/ssh/sshd_config`
	```
	AllowUsers my_cool_user my_cool_user_second
	PermitRootLogin no
	PasswordAuthentication yes
	```

* `service ssh restart`

* `ssh-copy-id my_cool_user@vps_server_ip`
* `ssh my_cool_user@vps_server_ip`

* add in `/etc/ssh/sshd_config`
	```
	PasswordAuthentication no
	```

* `sudo service ssh restart`


### 2. Firewall setup:
* `sudo apt install ufw`
* `sudo ufw allow OpenSSH`
* `sudo ufw enable`


### 3. Nginx setup:
* `sudo apt install nginx -y`

* `sudo touch /etc/nginx/sites-available/main.conf`
* add in `/etc/nginx/sites-available/main.conf`
	```
	server {
		server_name vps_server_ip;

		location / {
				include proxy_params;
				proxy_pass http://127.0.0.1:django_app_port;
		}

		location /static/ {
				alias /var/my_cool_user/django/static/;
		}
	}
	```
* `sudo ln -s /etc/nginx/sites-available/main.conf /etc/nginx/sites-enable/`
	
* `sudo ufw allow 'Nginx Full'`


### 4. Docker setup:
* Install docker https://docs.docker.com/engine/install/debian/
* `sudo usermod -aG docker my_cool_user `

* run docker compose to create network
* `docker network ls` - get us `network_name`
* `docker network inspect network_name` - get `ip_docker_host` in Gateway and `subnet_docker_host` in Subnet
* `sudo ufw allow from subnet_docker_host to any port 5432 proto tcp`
* `sudo ufw deny from any to any port 5432`
	
### 5. Postgres setup
* `sudo apt install postgresql`
* `sudo -u postgres psql`:
	```		
	CREATE DATABASE db_name;
	CREATE USER db_user WITH PASSWORD 'mypassword';
	GRANT ALL PRIVILEGES ON DATABASE db_name TO db_user;
	ALTER DATABASE db_name OWNER TO db_user;
	```

* add in `/etc/postgresql/17/main/postgresql.conf`
	```
	listen_adressess = 'localhost,ip_docker_host'
	```
	
* add in `/etc/postgresql/17/main/pg_hba.conf`
	```
	host	db_name		db_user		subnet_docker_host	md5
	```
	
* `sudo service postgresql restart`
	
* if external connection to db is needed:		
	* `sudo ufw allow from external_client_ip to any port 5432 proto tcp`
	* add in `/etc/postgresql/17/main/postgresql.conf`
		```
		listen_adressess = 'localhost,ip_docker_host,vps_server_ip'
		```
	* add in `/etc/postgresql/17/main/pg_hba.conf`
		```
		host	db_name		db_user		0.0.0.0/0			md5
		```


## Setup for local development:		
* `cp .env.template src/.env`
* `make prepare`
* `make up`