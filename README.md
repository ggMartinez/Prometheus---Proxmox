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

After run, you can access to Grafana in the port 3000, and Prometheus in the port 9090 of the host where this is running.

# How to use

## Add servers
In the directory `ServiceDiscovery` you can add any json file with definition of servers to monitor. Follow the syntax of the example file:
```
[
      {
        "labels": {
          "name": "Server 1"
        },
        "targets": [
          "192.168.1.10:9100"
        ]
      }
      {
        "labels": {
          "name": "Server 2"
        },
        "targets": [
          "192.168.1.11:9100"
        ]
      }
]
   ```

You can add all the json files that you want. No need to restart prometheus to catch them.

Also, there's a section for service discovery for AWS in `Configs/Prometheus/Config.yml` commented, that you would like to check.


## Alerts
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


