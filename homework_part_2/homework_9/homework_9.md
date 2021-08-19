## Задание 1

```
FROM centos:7

RUN yum -y install perl-Digest-SHA wget java-11-openjdk
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-linux-x86_64.tar.gz
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-darwin-x86_64.tar.gz.sha512
RUN shasum -a 512 -c elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512  \
    && tar -xzf elasticsearch-7.14.0-linux-x86_64.tar.gz
RUN yum upgrade -y
ADD elasticsearch.yml /elasticsearch-7.14.0/config/
ENV JAVA_HOME=/elasticsearch-7.14.0/jdk/
ENV ES_HOME=/elasticsearch-7.14.0
RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch
RUN mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data \
    && chown -R elasticsearch:elasticsearch /elasticsearch-7.14.0/
RUN mkdir /elasticsearch-7.14.0/snapshots &&\
    chown elasticsearch:elasticsearch /elasticsearch-7.14.0/snapshots
USER elasticsearch
EXPOSE 9300 9200
CMD ["/usr/sbin/init"]
CMD ["/elasticsearch-7.14.0/bin/elasticsearch"]
```

```
[root@bcab6605fb84 config]# curl -X GET 'http://localhost:9200'
{
  "name" : "elastic",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "s2l4GBv8TbW1L7gEkLokFw",
  "version" : {
    "number" : "7.14.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1",
    "build_date" : "2021-07-29T20:49:32.864135063Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

Ссылка на образ
https://hub.docker.com/repository/docker/stema91/netology


## Задание 2.
```

~ ► curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}

~ ► curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}

~ ► curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}

~ ► curl -X GET 'http://localhost:9200/_cat/indices?v' 
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases hs0dWFnVTlqdlIjwv4cmRA   1   0         22            0     21.7mb         21.7mb
green  open   ind-1            RHsuCuWVSnOym54ZYL6D7g   1   0          0            0       208b           208b
yellow open   ind-3            HHqWIX6FRsK8zjKZx8MIBw   4   2          0            0       832b           832b
yellow open   ind-2            jlB9DYqjTuScO1ATmgMI3Q   2   1          0            0       416b           416b


~ ► curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

~ ► curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology_test",
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
  "active_shards_percent_as_number" : 44.44444444444444
}


~ ► curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty' 
{
  "cluster_name" : "netology_test",
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
  "active_shards_percent_as_number" : 44.44444444444444
}


~ ► curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}


~ ► curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
~ ► curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
~ ► curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}

```

Для индексов 2 и 3 у нас нет серверов куда можно синхронизировать данные, поэтому они имеют статус yellow 


## Задание 3

```
curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch-7.14.0/snapshots" }}'

[root@bcab6605fb84 ~]# curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
```
