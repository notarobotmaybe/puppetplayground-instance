#!/bin/bash

puppet_regenerate_ca()
{

  mv /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppet/ssl.$(date +%Y%m%d%H%M%s)
  # RuntimeError: Got 1 failure(s) while initializing: File[/etc/puppetlabs/puppet/ssl]: change from '0755' to '0771' failed: failed to set mode 0755 on /etc/puppetlabs/puppet/ssl: Operation not permitted - No message available
  chmod 0771 /etc/puppetlabs/puppet/.repo/ssl-repo
  ln -s /etc/puppetlabs/puppet/.repo/ssl-repo /etc/puppetlabs/puppet/ssl

  # https://puppet.com/docs/puppet/5.4/ssl_regenerate_certificates.html
  TEMP_MASTER=$(mktemp /tmp/puppetmastertmp.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
  $PUPPETBIN master --no-daemonize --verbose > $TEMP_MASTER 2>&1 &

  PID_TMP_MASTER=$!

  grep "Notice: Starting Puppet master" $TEMP_MASTER > /dev/null 2>&1
  while [ $? -ne 0 ];
  do
    sleep 5
    grep "Notice: Starting Puppet master" $TEMP_MASTER > /dev/null 2>&1
  done

  ps -e | awk '{ print $1 }' | grep $PID_TMP_MASTER > /dev/null 2>&1
  while [ $? -eq 0 ];
  do
    kill $PID_TMP_MASTER > /dev/null 2>&1
    sleep 1
    kill -9 $PID_TMP_MASTER > /dev/null 2>&1
    ps -e | awk '{ print $1 }' | grep $PID_TMP_MASTER > /dev/null 2>&1
  done

  rm $TEMP_MASTER
}

PUPPETBIN=$(which puppet 2>/dev/null)

if [ -z "$PUPPETBIN" ];
then
  if [ -e "/opt/puppetlabs/bin/puppet" ];
  then
    PUPPETBIN='/opt/puppetlabs/bin/puppet'
  else
    echo "puppet not found"
    exit 1
  fi
fi

R10KBIN=$(which r10k 2>/dev/null)
if [ -z "$R10KBIN" ];
then
  if [ -e "/opt/puppetlabs/puppet/bin/r10k" ];
  then
    R10KBIN='/opt/puppetlabs/puppet/bin/r10k'
  else
    echo "r10k not found"
    exit 1
  fi
fi


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

git config --global user.email "${EYP_ROBOT_EMAIL}"
git config --global user.name "${EYP_ROBOT_NAME}"


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
      grep -Eo "certname=${EYP_PUPPETFQDN}\b" /etc/puppetlabs/puppet/puppet.conf > /dev/null 2>&1
      if [ $? -ne 0 ];
      then
        echo "generating CA for ${EYP_PUPPETFQDN} for repo ${EYP_PM_SSL_REPO}"
        sed "s@\\bcertname[ ]*=.*\$@certname=${EYP_PUPPETFQDN}@" -i /etc/puppetlabs/puppet/puppet.conf
        puppet_regenerate_ca
        cd /etc/puppetlabs/puppet/.repo/ssl-repo
        git add --all
        git commit -va -m 'inicialitzacio'
        git push origin master
      fi

      # enable autocommit
      touch /etc/puppetlabs/puppet/.repo/ssl-repo/.autocommit.enabled

      chown puppet. /etc/puppetlabs/puppet/.repo/ssl-repo -R
    else
      # repo ssl clonat no esta buitl, no regenerem CA
      mv /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppet/ssl.$(date +%Y%m%d%H%M%s)
      sed "s@\\bcertname[ ]*=.*\$@certname=${EYP_PUPPETFQDN}@" -i /etc/puppetlabs/puppet/puppet.conf
      chmod 0771 /etc/puppetlabs/puppet/.repo/ssl-repo
      chown puppet. /etc/puppetlabs/puppet/.repo/ssl-repo -R
      ln -s /etc/puppetlabs/puppet/.repo/ssl-repo /etc/puppetlabs/puppet/ssl
    fi
  else
    grep -Eo "certname=${EYP_PUPPETFQDN}\b" /etc/puppetlabs/puppet/puppet.conf > /dev/null 2>&1
    if [ $? -ne 0 ];
    then
      echo "generating CA for ${EYP_PUPPETFQDN} without git repo"
      sed "s@\\bcertname[ ]*=.*\$@certname=${EYP_PUPPETFQDN}@" -i /etc/puppetlabs/puppet/puppet.conf
      puppet_regenerate_ca
    fi
  fi
else
  mv /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppet/ssl.$(date +%Y%m%d%H%M%s)
  sed "s@\\bcertname[ ]*=.*\$@certname=${EYP_PUPPETFQDN}@" -i /etc/puppetlabs/puppet/puppet.conf
  chmod 0771 /etc/puppetlabs/puppet/.repo/ssl-repo
  chown puppet. /etc/puppetlabs/puppet/.repo/ssl-repo -R
  ln -s /etc/puppetlabs/puppet/.repo/ssl-repo /etc/puppetlabs/puppet/ssl
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

# r10k - http://terrarum.net/blog/puppet-infrastructure-with-r10k.html

if [ ! -z "${EYP_PM_CUSTOMER_REPO}" ];
then
  mkdir -p /etc/puppetlabs/r10k/
  cat <<EOF > /etc/puppetlabs/r10k/r10k.yaml
---
:cachedir: /var/cache/r10k
:sources:
  :local:
    remote: ${EYP_PM_CUSTOMER_REPO}
    basedir: /etc/puppetlabs/code/environments
    ignore_branch_prefixes:
      - chg
      - chG
      - cHg
      - cHG
      - Chg
      - ChG
      - CHg
      - CHG
      - PRJ
      - PRj
      - PrJ
      - Prj
      - pRJ
      - pRj
      - prJ
      - prj
EOF
  /usr/local/bin/updatepuppet.sh
fi

if [ ! -z "${EYP_PM_FILES_REPO}" ];
then
  mkdir -p /var/puppet/files
  git clone "${EYP_PM_FILES_REPO}" /var/puppet/files
  cat <<EOF > /etc/puppetlabs/puppet/fileserver.conf
[files]
  path /var/puppet/files
  allow *
EOF
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf -n
