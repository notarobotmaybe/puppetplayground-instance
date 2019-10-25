FROM centos:centos7
MAINTAINER Jordi Prats

# TODO
# http://label-schema.org/rc1/#build-time-labels
LABEL org.label-schema.vendor="" \
      org.label-schema.url="https://github.com/NTTCom-MS" \
      org.label-schema.name="puppetmaster5" \
      org.label-schema.license="" \
      org.label-schema.version="5.5.6"\
      org.label-schema.vcs-url="https://github.com/NTTCom-MS/docker-puppetmaster5" \
      org.label-schema.vcs-ref="" \
      org.label-schema.build-date="2019-08-19T16:00:00.52Z" \
      org.label-schema.schema-version="1.0"

ENV EYP_PUPPETFQDN=puppet5
ENV HOME /root

ENV EYP_ROBOT_EMAIL robot@puppet5.pm5.docker
ENV EYP_ROBOT_NAME Puppet Robot

RUN mkdir /root/.ssh
RUN chmod 0700 /root/.ssh/

RUN mkdir -p /usr/local/bin/
RUN mkdir -p /usr/local/src

COPY validatecsr.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/validatecsr.sh
COPY runme.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/runme.sh
COPY deploy.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/deploy.sh
COPY updatepuppet.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/updatepuppet.sh
COPY profiled_bolt.sh /etc/profile.d/bolt.sh

COPY start_puppetmaster.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start_puppetmaster.sh

#
# utils
#
RUN yum install openssl git -y

#
# puppet install
#
RUN rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
RUN yum install puppetserver -y

RUN yum install epel-release -y
RUN yum install yamllint -y

RUN /opt/puppetlabs/puppet/bin/gem install r10k

# puppetdb support
RUN yum install puppetdb-terminus -y

#
# puppet config
#
COPY puppet.conf /etc/puppetlabs/puppet/puppet.conf
COPY logback.xml /etc/puppetlabs/puppetserver/logback.xml

# certname=puppet
# dns_alt_names=puppet.fqdn

# DFile=/var/run/puppetlabs/puppetserver/puppetserver.pid
# #set default privileges to -rw-r-----
# UMask=027
# ExecReload=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver reload
# ExecStart=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver start
# ExecStop=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver stop
# KillMode=process
# SuccessExitStatus=143
# StandardOutput=syslog

# https://www.example42.com/2017/06/05/puppet-reports-and-metrics/

# git clone options
RUN echo "UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config
RUN echo "StrictHostKeyChecking=no" >> /etc/ssh/ssh_config

COPY puppetdb.conf /etc/puppetlabs/puppet/puppetdb.conf
COPY routes.yaml /etc/puppetlabs/puppet/routes.yaml

#
# puppet-bolt via gem
#

RUN yum install -y make gcc ruby-devel
# canvi desde gem cap a paquet
RUN yum install puppet-bolt -y

RUN mkdir -p /root/.bolt
RUN mkdir -p /root/.puppetlabs/
COPY bolt.yml /root/.puppetlabs/

# git watcher

RUN yum install inotify-tools -y

# supervisor

RUN yum install supervisor -y
RUN mkdir -p /etc/supervisor.d/
COPY supervisor/autocommit.ini /etc/supervisor.d/
COPY supervisor/puppetmaster.ini /etc/supervisor.d/

EXPOSE 8140

CMD /bin/bash /usr/local/bin/runme.sh
