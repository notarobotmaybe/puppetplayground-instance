#!/bin/bash

/usr/bin/htpasswd -c -b /etc/nginx/.htpasswd admin "${EYP_PUPPETBOARD_PASSWORD}"

exec /usr/bin/supervisord -c /etc/supervisord.conf -n
