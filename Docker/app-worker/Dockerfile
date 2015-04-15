# JibJob App Worker
FROM jibjob/base-app:1.0.0
MAINTAINER Virgil Dimaguila "virgild@gmail.com"

VOLUME ["/app", "/app/public/system", "/vendor/bundle"]

ENTRYPOINT ["/usr/local/bin/worker.sh"]

COPY worker.sh /usr/local/bin/worker.sh
RUN chmod +x /usr/local/bin/worker.sh
