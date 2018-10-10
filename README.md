# docker-puppetmaster5

override example:

* puppetdb public port: 8888 (not required)
* puppetmaster public port: 9999

```yaml
version: "2.1"
services:
  puppetdb:
    ports:
      - 8888:8081/tcp
    environment:
      EYP_PUPPETFQDN: 'puppet5.systemadmin.es'
      EYP_PUPPETDB_EXTERNAL_PORT: '9999'
  puppetmaster:
    ports:
      - 9999:8140/tcp
    environment:
      EYP_PUPPETFQDN: 'puppet5.systemadmin.es'
      EYP_PM_SSL_REPO: 'ssh://git@demo.repo.systemadmin.es/puppet/ssl.git'
      EYP_PM_CUSTOMER_REPO: 'ssh://git@demo.repo.systemadmin.es/config/demo.git'
```

## puppet-bolt

You need **eyp-eyplib**, example usage:

```
[root@31b68e9fbe3f ~]# bolt plan run eyplib::pdbtest
[
  {
    "certname": "centos7.vm"
  }
]
[root@31b68e9fbe3f ~]#
```

```
[root@31b68e9fbe3f ~]#  bolt command run hostname --query 'inventory { facts.kernel = "Linux" }' -u jordi --run-as root
Started on centos7.vm...
Finished on centos7.vm:
  STDOUT:
    centos7.vm
Successful on 1 node: centos7.vm
Ran on 1 node in 0.60 seconds
[root@31b68e9fbe3f ~]# bolt command run hostname --query 'inventory { facts.kernel = "Linux" }' -u jordi --run-as root
Started on centos7.vm...
Finished on centos7.vm:
  STDOUT:
    centos7.vm
Successful on 1 node: centos7.vm
Ran on 1 node in 0.58 seconds
[root@31b68e9fbe3f ~]# bolt command run hostname --query 'inventory { facts.systemadmin_nodetype = "hola" }' -u jordi --run-as root
Ran on 0 nodes in 0.00 seconds
[root@31b68e9fbe3f ~]# bolt command run hostname --query 'inventory { facts.systemadmin_nodetype = "hola" }' -u jordi --run-as root
Started on centos7.vm...
Finished on centos7.vm:
  STDOUT:
    centos7.vm
Successful on 1 node: centos7.vm
Ran on 1 node in 0.54 seconds
[root@31b68e9fbe3f ~]# bolt command run hostname --query 'inventory { facts.systemadmin_nodetype = "hola" and facts.kernel = "Linux" }' -u jordi --run-as root
Started on centos7.vm...
Finished on centos7.vm:
  STDOUT:
    centos7.vm
Successful on 1 node: centos7.vm
Ran on 1 node in 0.88 seconds
[root@31b68e9fbe3f ~]# bolt command run hostname --query 'inventory { facts.systemadmin_nodetype = "hola" and facts.kernel = "Windows" }' -u jordi --run-as root
Ran on 0 nodes in 0.00 seconds
[root@31b68e9fbe3f ~]#
```

## testing puppetdb API

```
[root@9ce853ab751c /]# curl -X GET https://puppetdb.pm5.docker:8081/pdb/query/v4 --data-urlencode 'query=nodes[certname] {}' --cert /etc/puppetlabs/puppet/ssl/certs/9ce853ab751c.nttcom.ms.local.pem --key //etc/puppetlabs/puppetdb/ssl/private.pem --cacert //etc/puppetlabs/puppetdb/ssl/ca.pem
[{"certname":"centos7.vm"}][root@9ce853ab751c /]#
```
