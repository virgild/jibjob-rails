FROM jibjob/base:1.0.0
MAINTAINER Virgil Dimaguila "virgild@gmail.com"

ENV RUBY_VERSION 2.2.1
ENV RUBY_DIR /opt/ruby/${RUBY_VERSION}
ENV RUBY_PATH ${RUBY_DIR}/bin

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
    DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:git-core/ppa && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git libssl-dev libncurses-dev gcc make libffi-dev libreadline-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp && \
    git clone https://github.com/sstephenson/ruby-build.git && \
    cd ruby-build && ./install.sh && \
    ruby-build ${RUBY_VERSION} /opt/ruby/${RUBY_VERSION} && \
    rm -rf /tmp/* && \
    cd / && \
    ${RUBY_PATH}/gem install bundler --no-rdoc --no-ri
