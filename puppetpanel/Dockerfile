FROM eyp/voxpopuli-puppetboard
MAINTAINER Jordi Prats

ENV EYP_PUPPETBOARD_PASSWORD="e382ff445aaf597f33f5ba43b94f5e6b"

RUN apk update
RUN apk add bash && apk add nginx && apk add supervisor && apk add apache2-utils

RUN mkdir -p /etc/supervisor.d/
RUN mkdir -p /run/nginx/
COPY supervisor/gunicorn.ini /etc/supervisor.d/
COPY supervisor/nginx.ini /etc/supervisor.d/

COPY nginx/daemon.conf /etc/nginx/modules/
COPY nginx/default.conf /etc/nginx/conf.d/

RUN mkdir -p /usr/local/bin
COPY runme.sh /usr/local/bin/runme.sh
RUN chmod +x /usr/local/bin/runme.sh

EXPOSE 80

CMD /usr/local/bin/runme.sh
