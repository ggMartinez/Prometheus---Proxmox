#!/bin/bash
DIRS="grafana_data
prometheus_data
alertmanager_data"

for dir in $DIRS
do
    mkdir $dir
    chmod 777 $dir
done