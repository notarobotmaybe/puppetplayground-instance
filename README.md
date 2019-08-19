# docker-puppetmaster5

override example:

Published ports:
* puppetdb public port: 8888 (not required)
* puppetmaster public port: 9999

Environment variables:
* puppetdb
  - EYP_PUPPETFQDN
  - EYP_PUPPETDB_EXTERNAL_PORT
* puppetmaster
  - EYP_PUPPETFQDN
  - EYP_PM_SSL_REPO
  - EYP_PM_CUSTOMER_REPO
  - EYP_ROBOT_EMAIL
  - EYP_ROBOT_NAME

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
      EYP_ROBOT_EMAIL: 'robot@puppet5.pm5.docker'
      EYP_ROBOT_NAME: 'Puppet Robot'
```

## build

### utils

```
bash update.utils.sh
```

### voxpopuli/puppetboard

```
cd puppetboard
docker build -t voxpupuli/puppetboard .
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

### list nodes

```
[root@9494992ca5c4 /]# curl -X GET https://puppetdb.pm5.docker:8081/pdb/query/v4 --data-urlencode 'query=nodes[certname] {}' --cert /etc/puppetlabs/puppet/ssl/certs/9494992ca5c4.cm.nttcom.ms.pem --key //etc/puppetlabs/puppetdb/ssl/private.pem --cacert //etc/puppetlabs/puppetdb/ssl/ca.pem | python -mjson.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   430  100   396  100    34   1937    166 --:--:-- --:--:-- --:--:--  1941
[
    {
        "certname": "42nlgjqe2h2eredm4ifjwqngvg.bx.internal"
    },
    {
        "certname": "0bnu1a0friuufjogmzwkyito3a.ax.internal"
    },
    {
        "certname": "0bnu1a0friuufjogmzwkyito3a.ax.internal"
    },
    {
        "certname": "42nlgjqe2h2eredm4ifjwqngvg.bx.internal"
    },
    {
        "certname": "uolnwlaen5fexd5mxxqszeqnah.ix.internal"
    }
]
```

### node details

```
[root@9494992ca5c4 /]# curl -X GET https://puppetdb.pm5.docker:8081/pdb/query/v4/nodes --cert /etc/puppetlabs/puppet/ssl/certs/9494992ca5c4.cm.nttcom.ms.pem --key //etc/puppetlabs/puppetdb/ssl/private.pem --cacert //etc/puppetlabs/puppetdb/ssl/ca.pem | python -mjson.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3081  100  3081    0     0  16445      0 --:--:-- --:--:-- --:--:-- 16475
[
    {
        "cached_catalog_status": "not_used",
        "catalog_environment": "production",
        "catalog_timestamp": "2019-03-18T08:47:15.636Z",
        "certname": "uolnwlaen5fexd5mxxqszeqnah.ix.internal",
        "deactivated": null,
        "expired": null,
        "facts_environment": "production",
        "facts_timestamp": "2019-03-18T08:47:10.224Z",
        "latest_report_corrective_change": null,
        "latest_report_hash": "a4cca3e52ffe10add964cc8e4e2875e3d5cfe7e5",
        "latest_report_job_id": null,
        "latest_report_noop": false,
        "latest_report_noop_pending": false,
        "latest_report_status": "unchanged",
        "report_environment": "production",
        "report_timestamp": "2019-03-18T08:47:19.297Z"
    },
    {
        "cached_catalog_status": "not_used",
        "catalog_environment": "production",
        "catalog_timestamp": "2019-03-18T08:39:17.591Z",
        "certname": "42nlgjqe2h2eredm4ifjwqngvg.bx.internal",
        "deactivated": null,
        "expired": null,
        "facts_environment": "production",
        "facts_timestamp": "2019-03-18T08:39:12.441Z",
        "latest_report_corrective_change": null,
        "latest_report_hash": "2ea30b5546c5921e147e810ca3b35d2eaf7ad276",
        "latest_report_job_id": null,
        "latest_report_noop": false,
        "latest_report_noop_pending": false,
        "latest_report_status": "unchanged",
        "report_environment": "production",
        "report_timestamp": "2019-03-18T08:39:21.132Z"
    },
    {
        "cached_catalog_status": "not_used",
        "catalog_environment": "production",
        "catalog_timestamp": "2019-03-18T08:58:21.352Z",
        "certname": "42nlgjqe2h2eredm4ifjwqngvg.bx.internal",
        "deactivated": null,
        "expired": null,
        "facts_environment": "production",
        "facts_timestamp": "2019-03-18T08:58:15.951Z",
        "latest_report_corrective_change": null,
        "latest_report_hash": "1aaf7e6a5ab0233a55d18f1f16f58a995de72fd6",
        "latest_report_job_id": null,
        "latest_report_noop": false,
        "latest_report_noop_pending": false,
        "latest_report_status": "unchanged",
        "report_environment": "production",
        "report_timestamp": "2019-03-18T08:58:24.622Z"
    },
    {
        "cached_catalog_status": "not_used",
        "catalog_environment": "production",
        "catalog_timestamp": "2019-03-18T08:59:32.215Z",
        "certname": "0bnu1a0friuufjogmzwkyito3a.ax.internal",
        "deactivated": null,
        "expired": null,
        "facts_environment": "production",
        "facts_timestamp": "2019-03-18T08:59:26.583Z",
        "latest_report_corrective_change": null,
        "latest_report_hash": "c1698ccf3cd35976de9400d2962c81030825e700",
        "latest_report_job_id": null,
        "latest_report_noop": false,
        "latest_report_noop_pending": false,
        "latest_report_status": "unchanged",
        "report_environment": "production",
        "report_timestamp": "2019-03-18T08:59:35.665Z"
    },
    {
        "cached_catalog_status": "not_used",
        "catalog_environment": "production",
        "catalog_timestamp": "2019-03-18T09:04:28.606Z",
        "certname": "0bnu1a0friuufjogmzwkyito3a.ax.internal",
        "deactivated": null,
        "expired": null,
        "facts_environment": "production",
        "facts_timestamp": "2019-03-18T09:04:23.522Z",
        "latest_report_corrective_change": null,
        "latest_report_hash": "4f5b611e7f4d25b2a92a4e90db18a2d8738a63dc",
        "latest_report_job_id": null,
        "latest_report_noop": false,
        "latest_report_noop_pending": false,
        "latest_report_status": "unchanged",
        "report_environment": "production",
        "report_timestamp": "2019-03-18T09:04:31.794Z"
    }
]
```
