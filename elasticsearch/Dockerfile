FROM ubuntu:16.04
MAINTAINER Jordi Prats

# TODO
# http://label-schema.org/rc1/#build-time-labels
LABEL org.label-schema.vendor="" \
      org.label-schema.url="" \
      org.label-schema.name="" \
      org.label-schema.license="" \
      org.label-schema.version=""\
      org.label-schema.vcs-url="" \
      org.label-schema.vcs-ref="" \
      org.label-schema.build-date="" \
      org.label-schema.schema-version=""

ENV EYP_PUPPETFQDN=puppet5
ENV HOME /root

RUN mkdir /root/.ssh
RUN chmod 0700 /root/.ssh/
RUN mkdir -p /usr/local/bin/
RUN mkdir -p /usr/local/src/

RUN apt-get update
RUN apt-get install software-properties-common -y

RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN bash -c 'yes | apt-get install curl wget oracle-java8-installer net-tools iputils-ping -y'

COPY deb/es.deb /usr/local/src/es.deb
RUN dpkg -i /usr/local/src/es.deb
RUN usermod -s /bin/bash elasticsearch

COPY start_es.sh /usr/local/bin/start_es.sh
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

VOLUME ["/var/lib/elasticsearch"]
VOLUME ["/var/log/elasticsearch"]

EXPOSE 9200

CMD /bin/bash /usr/local/bin/start_es.sh
