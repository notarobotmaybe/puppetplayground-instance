#!/bin/bash
cd /opt/puppet-instances/playground/instance
docker-compose -p playground exec puppetmaster /usr/local/bin/updatepuppet.sh
cd $OLDPWD
