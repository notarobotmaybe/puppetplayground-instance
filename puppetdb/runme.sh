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

su - postgres -c "/usr/pgsql-9.6/bin/postmaster -D ${PGDATA}" &

for i in $(seq 1 60);
do
  sleep 1

  /usr/pgsql-9.6/bin/pg_isready > /dev/null 2>&1

  IS_READY=$?

  if [ $IS_READY -ne 0 ] && [ $i -eq 60 ];
  then
    echo "error starting postgres"
    exit 1
  fi

  if [ $IS_READY -eq 0 ];
  then
    break;
  fi
done
