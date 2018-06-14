#!/bin/bash

# If a custom policy executable is configured, the CA puppet master
# will run it every time it receives a CSR. The executable will
# be passed the subject CN of the request as a command line argument,
# and the contents of the CSR in PEM format on stdin. It should
# exit with a status of 0 if the cert should be autosigned
# and non-zero if the cert should not be autosigned.

cat <&0 > /dev/null

if [ -z "$1" ];
then
  echo "error - no CN"
  exit 1
fi

# CN needs to be a FQDN, so let's check if it contains at least one level
echo "$1" | grep "\."

exit $?
