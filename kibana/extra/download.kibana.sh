#!/bin/bash
KIBANA_DEB=$(curl https://www.elastic.co/downloads/kibana 2>/dev/null  | grep "zip-link" | grep -i ">deb" | sed 's/.*href *= *"\?\([^" ]\+\)"\?.*/\1/')
wget "${KIBANA_DEB}" -O deb/kibana.deb
