#!/bin/bash
LOGSTASH_DEB=$(curl https://www.elastic.co/downloads/logstash 2>/dev/null  | grep "zip-link" | grep -i ">deb" | sed 's/.*href *= *"\?\([^" ]\+\)"\?.*/\1/')
wget "${LOGSTASH_DEB}" -O deb/logstash.deb
