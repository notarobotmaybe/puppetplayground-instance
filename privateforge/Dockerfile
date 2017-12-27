FROM ubuntu:14.04
MAINTAINER Jordi Prats

ENV HOME /root

#
# timezone and locale
#
RUN echo "Europe/Andorra" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

RUN export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN DEBIAN_FRONTEND=noninteractive apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install wget -y

#ruby

RUN DEBIAN_FRONTEND=noninteractive apt-get install ruby gcc ruby-dev make autoconf -y

#https://github.com/unibet/puppet-forge-server

RUN gem install puppet-forge-server

RUN mkdir -p /var/forge/modules

VOLUME ["/var/forge/modules"]

EXPOSE 8080

CMD /usr/local/bin/puppet-forge-server -m /var/forge/modules -x http://forge.puppetlabs.com
