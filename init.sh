#!/bin/bash
DIRS="grafana_data
prometheus_data
alertmanager_data"

chmod 755 -R Configs

for dir in $DIRS
do
    mkdir $dir
    chmod 777 $dir
done
