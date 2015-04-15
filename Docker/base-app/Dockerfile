# JibJob Base App
FROM jibjob/base-ruby
MAINTAINER Virgil Dimaguila "virgild@gmail.com"

# Install app gem requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libpq-dev g++ imagemagick pdftk xfonts-base xfonts-75dpi && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Postgresql 9.4 client
COPY files/pgdg.list /etc/apt/sources.list.d/pgdg.list
RUN locale-gen en_US.UTF-8 && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-client-9.4 && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install wkhtmltopdf
COPY files/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb /tmp/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
RUN cd /tmp && \
    dpkg -i ./wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get install -f && \
    rm /tmp/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb

# Provide /opt/fonts/local.conf
# or Insert <dir>/opt/fonts</dir> to /etc/fonts/fonts.conf
# mkdir -p /opt/fonts/truetype && chown -R jibjob /opt/fonts
RUN cd /etc/fonts && \
    cp fonts.conf local.conf && \
    sed -i 's/<dir>\/usr\/share\/fonts<\/dir>/<dir>\/usr\/share\/fonts<\/dir><dir>\/opt\/fonts<\/dir>/' local.conf && \
    mkdir -p /opt/fonts/truetype && \
    chown -R jibjob: /opt/fonts

# RUN mkdir -p /vendor/bundle && \
#     chown -R jibjob: /vendor && \
#     mkdir -p /app && \
#     chown -R jibjob: /app

# VOLUME ["/app", "/app/public/system", "/vendor/bundle"]
