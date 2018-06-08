#!/bin/bash
PGDATA=/var/lib/pgsql/9.6/data
# postgresql::hba_rule { 'IPv4/any puppetdb':
#   user     => 'puppetdb',
#   database => 'puppetdb',
#   address  => '0.0.0.0/0',
# }
#
# postgresql::role { 'puppetdb':
#   password => 'X_PUPPETDB_PASSWORD_X',
# }
#
# postgresql::db { 'puppetdb':
#   owner => 'puppetdb',
# }

/usr/pgsql-9.6/bin/postmaster -D ${PGDATA}
