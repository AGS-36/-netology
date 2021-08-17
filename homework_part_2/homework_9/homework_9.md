## Задание 1.
```

FROM centos:7

RUN yum -y install perl-Digest-SHA wget java-1.8.0-openjdk
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-linux-x86_64.tar.gz
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-darwin-x86_64.tar.gz.sha512
RUN shasum -a 512 -c elasticsearch-7.14.0-darwin-x86_64.tar.gz.sha512
RUN tar -xzf elasticsearch-7.14.0-linux-x86_64.tar.gz
RUN cd elasticsearch-7.14.0/
EXPOSE 9300 9200
ENV JAVA_HOME=/usr/lib/jvm/jre-openjdk
CMD ["/usr/share/elasticsearch/bin/elasticsearch","-Epath.conf=/etc/elasticsearch"]
```

## Задание 2.
```

[root@bcab6605fb84 config]# curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"error":{"root_cause":[{"type":"resource_already_exists_exception","reason":"index [ind-1/cQuhNzeqRruFBr6RMEmCyQ] already exists","index_uuid":"cQuhNzeqRruFBr6RMEmCyQ","index":"ind-1"}],"type":"resource_already_exists_exception","reason":"index [ind-1/cQuhNzeqRruFBr6RMEmCyQ] already exists","index_uuid":"cQuhNzeqRruFBr6RMEmCyQ","index":"ind-1"},"status":400}[root@bcab6605fb84 config]# curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": {mber_of_shards": 2,  "number_of_replicas": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}[root@bcab6605fb84 config]# curl -X PUT localhost:9200/mber_of_shards": 4,  "number_of_replicas": 2 }}'    ings": { "num
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}[root@bcab6605fb84 config]#

[root@bcab6605fb84 config]# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases zrWNIZslTOCS3T1bPLLjJw   1   0         42            0     40.6mb         40.6mb
yellow open   ind-1            cQuhNzeqRruFBr6RMEmCyQ   1   1          0            0       208b           208b
yellow open   ind-3            tmsp7WYGS_uaLwpqa9TdqA   4   2          0            0       832b           832b
yellow open   ind-2

[root@bcab6605fb84 config]# curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 1,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 42.10526315789473


  [root@bcab6605fb84 config]# curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 42.10526315789473


  [root@bcab6605fb84 config]# curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 42.10526315789473
```

