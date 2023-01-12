# Prometheus

Prometheus, Grafana and Alert Manager ready to run on Docker

## Pre-requisites
Install Docker and Docker Compose on the server to run this. In CentOS run `yum install -y docker docker-compose`

Also, in the targets to monitor install Prometheus node exporter. The easiest way is with docker:
```
docker run -d \  
--net="host" \  
--pid="host" \  
-v "/:/host:ro,rslave" \  
prom/node-exporter:latest \  
--path.rootfs=/host
```
For more info on node exporter: [Node Exporter GitHub Page](https://github.com/prometheus/node_exporter)


# How to use
First edit `Configs/AlertManager/Config.yml` and modify the SMTP settings:
```
receivers:
- name: 'mail-notifications'
  email_configs:
	- to: from@domain.com
	from: to@domain.com
	smarthost: smtp-server:587
	auth_username: username
	auth_identity: identity
	auth_password: password
	send_resolved: true
```
Then, run:
`docker-compose up -d`
