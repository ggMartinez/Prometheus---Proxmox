# Prometheus

Prometheus, Grafana and Alert Manager ready to run on Docker

## Pre-requisites
Install Docker and Docker Compose on the server to run this. In CentOS run `yum install -y docker docker-compose`

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
## Run Prometheus
Just run:
`docker-compose up -d`

After run, you can access to Grafana in the port 3000, and Prometheus in the port 9090 of the host where this is running.


# Install Node Exporter
You need to install Node Exporter in the servers to monitor. Be aware that the Prometheus' server will have to connect to port TCP 9100 to the servers that run the exporter.

The easiest way is with docker:
```
docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" prom/node-exporter:latest --path.rootfs=/host
```
To install directly to the server without docker, first add the Prometheus repository, creating the file `/etc/yum.repos.d/prometheus.repo`:

```
[prometheus]
name=prometheus
baseurl=https://packagecloud.io/prometheus-rpm/release/el/$releasever/$basearch
repo_gpgcheck=1
enabled=1
gpgkey=https://packagecloud.io/prometheus-rpm/release/gpgkey
       https://raw.githubusercontent.com/lest/prometheus-rpm/master/RPM-GPG-KEY-prometheus-rpm
gpgcheck=1
metadata_expire=300
```
After that, run this commands:
```
yum install -y node_exporter
systemctl enable node_exporter
systemctl start node_exporter 
```
