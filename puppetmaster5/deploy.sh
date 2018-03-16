#!/bin/bash

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

echo "Installing modules"
$R10KBIN deploy environment $1 -p

for PUPPET_ENVIRONMENT in $(find /etc/puppetlabs/code/environments/ -maxdepth 1 -mindepth 1 -type d | rev | cut -f1 -d/ | rev);
do
  echo -n "Installing dependencies for ${PUPPET_ENVIRONMENT}..."
  # instala dependencies
  for i in $($PUPPETBIN module list --environment ${PUPPET_ENVIRONMENT}  2>&1 | grep "Warning: Missing dependency" | cut -f2 -d\');
  do
    $PUPPETBIN module install $i --environment ${PUPPET_ENVIRONMENT} > /dev/null 2>&1
  done
  echo " OK"
  $PUPPETBIN module list --environment ${PUPPET_ENVIRONMENT}
  echo -e "\n"

done
