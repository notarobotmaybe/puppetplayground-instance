#!/bin/bash

# ps auxf | grep puppetserver | grep java | wc -l
if [ "$(ps auxf | grep puppetserver | grep java | wc -l)" -ne 1 ];
then
  /opt/puppetlabs/server/apps/puppetserver/bin/puppetserver foreground
fi
