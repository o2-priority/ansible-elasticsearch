Elasticsearch
=============

Ansible role to install and configure Elasticsearch.

This role has been tested with Elasticsearch 5 and 6 only

*Note:* 

- It is recommended to use Oracle JDK version 1.8.0\_72
- Discoveries supported
  - EC2 Discovery
  - Zen Discovery
  
Xpack plugin has been enabled for reporting purpose.
The type of licensing we use for xpack in basic. Since we are on elasticsearch version 6.2, the basic license will have to be renewed annually for the reporting to work.

Go to https://register.elastic.co/ to renew basic license.

## Examples

```
- hosts: eshost

  vars:
    elasticsearch_version: 5.2.0
    elasticsearch_cluster_name: myCluster

  roles:
    - wunzeco.elasticsearch
```


## Testing

To test this role, run:

```
kitchen test
```


## Dependencies:

None
