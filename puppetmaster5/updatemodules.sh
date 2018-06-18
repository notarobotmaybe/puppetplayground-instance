#!/bin/bash

puppet_check()
{
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
}

r10k_check()
{
  R10KBIN=$(which r10k 2>/dev/null)

  if [ -z "$R10KBIN" ];
  then
    if [ -e "/opt/puppetlabs/bin/r10k" ];
    then
      R10KBIN='/opt/puppetlabs/bin/r10k'
    elif [ -e "/opt/puppetlabs/puppet/bin/r10k" ];
    then
      R10KBIN='/opt/puppetlabs/puppet/bin/r10k'
    else
      R10KBIN=$(find /opt/puppetlabs -type f -name r10k | head -n1)
      if [ -z "$R10KBIN" ];
      then
        if [ ! -e "$R10KBIN" ];
        then
          echo "r10k not found"
          exit 1
        fi
      fi
    fi
  fi
}

puppet_check
r10k_check

$R10KBIN deploy environment -p

for ENV in /etc/puppetlabs/code/environments/*;
do
  echo "Installing dependencies - $ENV"

  for i in $($PUPPETBIN module list --modulepath=$ENV/modules 2>&1 | grep "Warning: Missing dependency" | cut -f2 -d\');
  do
    $PUPPETBIN module install $i --modulepath=$ENV/modules > /dev/null 2>&1
  done

  echo "Dependencies installed"

done
