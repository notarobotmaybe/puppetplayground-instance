#!/bin/bash

if [ "$(find /etc/puppetlabs/puppet -iname ssl -empty | wc -l)" -eq 1 ];
then
  echo "generating CA for ${EYP_PUPPETFQDN}"
  sed "s@\\bcertname[ ]*=.*\$@certname=${EYP_PUPPETFQDN}@" -i /etc/puppetlabs/puppet/puppet.conf
  puppet ca generate ${EYP_PUPPETFQDN}
fi

if [ -e "$(ls -A /var/log/puppetlabs)" ];
then
  # [root@dfb15f17b346 /]# find /var/log/puppetlabs -ls
  # 2777198    4 drwxr-xr-x   6 root     root         4096 Dec 27 10:24 /var/log/puppetlabs
  # 2818307    4 drwxr-x---   2 root     root         4096 Nov  2 08:12 /var/log/puppetlabs/mcollective
  # 2818308    4 drwxr-x---   2 root     root         4096 Nov  2 08:12 /var/log/puppetlabs/puppet
  # 2818309    4 drwx------   2 puppet   puppet       4096 Nov  2 18:06 /var/log/puppetlabs/puppetserver
  # 2818310    4 drwxr-x---   2 root     root         4096 Nov  2 08:12 /var/log/puppetlabs/pxp-agent
  mkdir -p  /var/log/puppetlabs/mcollective \
            /var/log/puppetlabs/puppet \
            /var/log/puppetlabs/puppetserver \
            /var/log/puppetlabs/pxp-agent

  chomd 0750  /var/log/puppetlabs/mcollective \
              /var/log/puppetlabs/puppet \
              /var/log/puppetlabs/pxp-agent

  chown puppet.puppet /var/log/puppetlabs/puppetserver
  chmod 0700 /var/log/puppetlabs/puppetserver

fi


#ps auxf | grep puppetserver | grep java | wc -l
if [ "$(ps auxf | grep puppetserver | grep java | wc -l)" -ne 1 ];
then
  /opt/puppetlabs/server/apps/puppetserver/bin/puppetserver foreground
fi
