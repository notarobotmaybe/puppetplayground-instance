#!/bin/bash
ELASTIC_DEB=$(curl https://www.elastic.co/downloads/elasticsearch 2>/dev/null  | grep "zip-link" | grep ">deb<" | sed 's/.*href *= *"\?\([^" ]\+\)"\?.*/\1/')
wget "${ELASTIC_DEB}" -O deb/es.deb
