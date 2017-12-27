#!/bin/bash

if [ -z "$(ls -A /etc/puppetlabs)" ];
then
  # [root@e6c03ff466a1 puppetlabs]# ls -la
  # total 28
  # drwxr-xr-x  7 root   root   4096 Dec 27 12:32 .
  # drwxr-xr-x 64 root   root   4096 Dec 27 12:32 ..
  # drwxr-xr-x  4 root   root   4096 Dec 27 12:30 code
  # drwxr-xr-x  2 root   root   4096 Dec 27 12:30 mcollective
  # drwxr-xr-x  3 root   root   4096 Dec 27 12:32 puppet
  # drwxr-x---  4 puppet puppet 4096 Dec 27 12:32 puppetserver
  # drwxr-xr-x  3 root   root   4096 Dec 27 12:30 pxp-agent

  mkdir -p /etc/puppetlabs/code \
           /etc/puppetlabs/mcollective \
           /etc/puppetlabs/puppet \
           /etc/puppetlabs/puppetserver \
           /etc/puppetlabs/pxp-agent

  chown puppet.puppet /etc/puppetlabs/puppetserver
  chmod 0750 /etc/puppetlabs/puppetserver

  chmod 0755 /etc/puppetlabs/code \
             /etc/puppetlabs/mcollective \
             /etc/puppetlabs/puppet \
             /etc/puppetlabs/pxp-agent
fi

mkdir -p /etc/puppetlabs/puppet/.repo/ssl-repo
if [ -z "$(ls -A /etc/puppetlabs/puppet/.repo/ssl-repo)" ];
then
  if [ ! -z "${EYP_PM_SSL_REPO}" ];
  then
    cd /etc/puppetlabs/puppet/.repo/ssl-repo
    git init
    git remote add origin ${EYP_PM_SSL_REPO}
    git pull origin master

    if [ "$(find .git/objects -type f | wc -l)" -eq 0 ];
    then
      echo "generating CA for ${EYP_PUPPETFQDN} for repo ${EYP_PM_SSL_REPO}"
      sed "s@\\bcertname[ ]*=.*\$@certname=${EYP_PUPPETFQDN}@" -i /etc/puppetlabs/puppet/puppet.conf
      puppet ca generate ${EYP_PUPPETFQDN}
      cd /etc/puppetlabs/puppet/.repo/ssl-repo
      git add --all
      git commit -va -m 'inicialitzacio'
      git push origin master
    fi
  else
    echo "generating CA for ${EYP_PUPPETFQDN} without git repo"
    sed "s@\\bcertname[ ]*=.*\$@certname=${EYP_PUPPETFQDN}@" -i /etc/puppetlabs/puppet/puppet.conf
    puppet ca generate ${EYP_PUPPETFQDN}
  fi
  if [ ! -L /etc/puppetlabs/puppet/ssl ];
  then
    ln -s /etc/puppetlabs/puppet/.repo/ssl-repo /etc/puppetlabs/puppet/ssl
  fi
fi

if [ -z "$(ls -A /var/log/puppetlabs)" ];
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

cd /

#ps auxf | grep puppetserver | grep java | wc -l
if [ "$(ps auxf | grep puppetserver | grep java | wc -l)" -ne 1 ];
then
  /opt/puppetlabs/server/apps/puppetserver/bin/puppetserver foreground
fi
