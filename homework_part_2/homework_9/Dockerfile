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
