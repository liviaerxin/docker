FROM debian:9-slim

COPY sources.list /etc/apt/sources.list

RUN rm -rf /var/lib/apt/lists/* \
&& apt-get update \
&& apt-get install -y \
    gnupg \
    curl \
    dnsutils \
    httpie \
    iputils-ping \
    jq \
    mongodb-clients \
    mysql-client \
    net-tools \
    redis-tools \
    telnet \
    wget \
    traceroute \
    vim \
    && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean && apt-get autoremove

# taken from https://www.postgresql.org/download/linux/debian/
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' >  /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update \
&& apt-get install -y \
    postgresql-client-10 \
    && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean && apt-get autoremove


