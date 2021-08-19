FROM centos:7

RUN yum install perl-Digest-SHA wget java-11-openjdk -y
RUN  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-linux-x86_64.tar.gz \
    &&  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-linux-x86_64.tar.gz.sha512
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
