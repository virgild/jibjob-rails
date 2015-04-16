# JibJob App Developer Console
FROM jibjob/base-app:1.0.0
MAINTAINER Virgil Dimaguila "virgild@gmail.com"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tmux telnet dnsutils gcc make build-essential && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Redis CLI
RUN cd /tmp && \
    wget --quiet http://download.redis.io/releases/redis-3.0.0.tar.gz && \
    tar zxf redis-3.0.0.tar.gz && \
    cd redis-3.0.0 && \
    make && \
    cd /usr/local/bin && \
    cp /tmp/redis-3.0.0/src/redis-cli . && \
    rm -rf /tmp/redis-3.0.0.*

# Make jibjob sudoer
COPY jibjob_sudoer /etc/sudoers.d/jibjob

# root user config files
COPY tmux.conf /root/.tmux.conf

# jibjob user home files
COPY jibjob_home /home/jibjob/
COPY tmux.conf /home/jibjob/.tmux
RUN chown -R jibjob:jibjob /home/jibjob
