#!/bin/bash

R10KBIN=$(which r10k 2>/dev/null)
if [ -z "$R10KBIN" ];
then
  if [ -e "/opt/puppetlabs/bin/r10k" ];
  then
    R10KBIN='/opt/puppetlabs/puppet/bin/r10k'
  else
    echo "r10k not found"
    exit 1
  fi
fi


$R10KBIN deploy environment $1 -p
