#!/bin/bash

PGDATA=/var/lib/pgsql/9.6/data

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

# postgresql::role { 'puppetdb':
#   password => 'X_PUPPETDB_PASSWORD_X',
# }
if [ -z "$(psql -U postgres -tc "SELECT rolname FROM pg_roles WHERE rolname='puppetdb'")" ];
then
  psql -U postgres -tc "CREATE ROLE puppetdb LOGIN NOSUPERUSER ENCRYPTED PASSWORD '${EYP_POSTGRES_PUPPETDB_PASSWORD}';"
fi

# postgresql::db { 'puppetdb':
#   owner => 'puppetdb',
# }

if [ -z "$(psql -U postgres -tc "SELECT datname FROM pg_database WHERE datname='puppetdb'")" ];
then
  psql -U postgres -tc "CREATE DATABASE puppetdb OWNER puppetdb"
fi

sed "s/X_PUPPETDB_PASSWORD_X/${EYP_POSTGRES_PUPPETDB_PASSWORD}/g" -i /etc/puppetlabs/puppetdb/conf.d/database.ini

while [ ! -f "/etc/puppetlabs/puppet/ssl/certs/puppetdb.pm5.docker.pem" ];
do
  puppet agent --server puppet5 --masterport 8140 --certname puppetdb.pm5.docker --test
  sleep 5s
done

FQDN=$(puppet facts --render-as json | python -mjson.tool | grep fqdn | cut -f2 -d: | cut -f2 -d\")

ln -s /etc/puppetlabs/puppet/ssl/private_keys/puppetdb.pm5.docker.pem /etc/puppetlabs/puppet/ssl/private_keys/${FQDN}.pem
ln -s /etc/puppetlabs/puppet/ssl/certs/puppetdb.pm5.docker.pem /etc/puppetlabs/puppet/ssl/certs/${FQDN}.pem

ln -s /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppetdb/ssl

puppetdb ssl-setup -f

#
# puppetDB start
#

/opt/puppetlabs/server/apps/puppetdb/bin/puppetdb start


while [ $(ps -fea | grep java | grep puppetdb | wc -l) -ne 0 ];
do
  sleep 10;
done
