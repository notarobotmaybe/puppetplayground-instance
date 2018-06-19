# docker-puppetmaster5

## puppet-bolt

You need **eyp-eyplib**:

```
[root@31b68e9fbe3f ~]# bolt plan run eyplib::pdbtest
[
  {
    "certname": "centos7.vm"
  }
]
[root@31b68e9fbe3f ~]#
```


## testing puppetdb API

```
[root@9ce853ab751c /]# curl -X GET https://puppetdb.pm5.docker:8081/pdb/query/v4 --data-urlencode 'query=nodes[certname] {}' --cert /etc/puppetlabs/puppet/ssl/certs/9ce853ab751c.nttcom.ms.local.pem --key //etc/puppetlabs/puppetdb/ssl/private.pem --cacert //etc/puppetlabs/puppetdb/ssl/ca.pem
[{"certname":"centos7.vm"}][root@9ce853ab751c /]#
```
