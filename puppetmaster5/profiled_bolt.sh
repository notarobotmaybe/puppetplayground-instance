# /opt/puppetlabs/puppet/bin

if ! echo $PATH | grep -q /opt/puppetlabs/puppet/bin ; then
  export PATH=$PATH:/opt/puppetlabs/puppet/bin
fi
