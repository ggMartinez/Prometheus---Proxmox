# Prometheus - Proxmox Edition

Prometheus, Grafana and Alert Manager to monitor Proxmox Servers, ready to run on Docker,

## Pre-requisites
Install Docker and Docker Compose on the server to run this. In CentOS run `yum install -y docker docker-compose`

Also, pick a host (the same that will run this, a Proxmox Server with Docker, or any host) to run the software to do the Service Discovery Service for Proxmox. [You will find it here](https://github.com/ggMartinez/Prometheus-Proxmox-Service-Discovery), and configure it (also, wrapped up by me 😎, but the SD Software itself is not mine, owner reference on the repo), 

# How to use

## Clone this repository
First of all, clone this repository to the server with docker and docker compose that will run Prometheus, Alert Manager and Grafana:

`git clone https://github.com/ggMartinez/prometheus.git`



## Add Proxmox Servers
Copy the file `ProxmoxScrapingConfig.yml.example` into `ProxmoxScrapingConfig.yml` , and specify a Job Name and the Proxmox Service Discovery Service URL, for example:
```
scrape_configs:
    - job_name: my-proxmox-server
      http_sd_configs:
        - url: http://my-proxmox-service-discovery:8081/metrics
      relabel_configs:
      - replacement: ${1}:9100
        source_labels:
        - __meta_pve_ipv4
        target_label: __address__
      - source_labels:
        - __meta_pve_name
        target_label: instance
      - source_labels:
        - __meta_pve_name
        target_label: name
   ```




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
Just run inside this directory:
`docker-compose up -d`

After run, you can access to Grafana in the port 3000, and Prometheus in the port 9090 of the host where this is running. It will discover the Proxmox VMs. The Service Discovery Serivice can filter up them if you want.


# Install Node Exporter
You need to install Node Exporter in the VMs to monitor. Also, you need the Qemu Agent installed and configured on the VMs to discover IP and name automatically. Go to Proxmox docs for that. 

Be aware that the Prometheus' server will have to connect to port TCP 9100 to the servers that run the exporter.

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
