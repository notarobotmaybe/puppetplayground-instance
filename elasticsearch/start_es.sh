#!/bin/bash

ulimit -n 65536 
ulimit -u 2048


export ES_HOME=/usr/share/elasticsearch
export ES_PATH_CONF=/etc/elasticsearch
export PID_DIR=/var/run/elasticsearch
#EnvironmentFile=-/etc/default/elasticsearch
export ES_PATH_CONF=/etc/elasticsearch
export ES_STARTUP_SLEEP_TIME=5

cd /usr/share/elasticsearch

su elasticsearch -c "/usr/share/elasticsearch/bin/elasticsearch -p ${PID_DIR}/elasticsearch.pid"
