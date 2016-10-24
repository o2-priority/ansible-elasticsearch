Elasticsearch
=============

Ansible role to install and configure Elasticsearch.

This role has been tested with Elasticsearch v2.2 only

*Note:* 

- It is recommended to use Oracle JDK version 1.8.0\_72
- Discoveries supported
  - EC2 Discovery
  - Zen Discovery

## Examples

```
- hosts: eshost

  vars:
    elasticsearch_version: 2.2
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
