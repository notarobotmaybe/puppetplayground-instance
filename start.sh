#!/bin/bash
cd /opt/puppet-instances/playground/instance
bash update.utils.sh
docker-compose -p playground up -d
cd $OLDPWD
