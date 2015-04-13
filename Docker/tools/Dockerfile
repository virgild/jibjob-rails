FROM jibjob/base:1.0.0
MAINTAINER Virgil Dimaguila "virgild@gmail.com"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y telnet dnsutils gcc make build-essential && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp && \
    wget --quiet http://download.redis.io/releases/redis-3.0.0.tar.gz && \
    tar zxf redis-3.0.0.tar.gz && \
    cd redis-3.0.0 && \
    make && \
    cd /usr/local/bin && \
    cp /tmp/redis-3.0.0/src/redis-cli . && \
    rm -rf /tmp/redis-3.0.0.*

COPY pgdg.list /etc/apt/sources.list.d/pgdg.list
RUN locale-gen en_US.UTF-8 && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-client-9.4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
