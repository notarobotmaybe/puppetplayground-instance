#!/bin/bash

if [ "$(find /etc/puppetlabs/puppet -iname ssl -empty | wc -l)" -eq 1 ];
then
  echo "generating CA for ${EYP_PUPPETFQDN}"
  sed "s@\\bcertname[ ]*=.*\$@certname=${EYP_PUPPETFQDN}@" -i /etc/puppetlabs/puppet/puppet.conf
  puppet ca generate ${EYP_PUPPETFQDN}
fi

#ps auxf | grep puppetserver | grep java | wc -l
if [ "$(ps auxf | grep puppetserver | grep java | wc -l)" -ne 1 ];
then
  /opt/puppetlabs/server/apps/puppetserver/bin/puppetserver foreground
fi
