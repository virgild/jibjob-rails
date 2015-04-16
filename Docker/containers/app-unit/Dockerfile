FROM jibjob/base-app:1.0.0
MAINTAINER Virgil Dimaguila "virgild@gmail.com"

ENV PATH ${RUBY_PATH}:${PATH}

RUN git clone -b docker --depth 1 https://github.com/virgild/jibjob-rails.git /app && \
    rm -rf /app/.git && \
    chown -R jibjob:jibjob /app && \
    cd /app && \
    gosu jibjob bundle install --path=/vendor/bundle
