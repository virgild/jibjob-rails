# JibJob Base App
FROM jibjob/base-ruby:1.0.0
MAINTAINER Virgil Dimaguila "virgild@gmail.com"

# Install app gem requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libpq-dev g++ imagemagick pdftk xfonts-base xfonts-75dpi libcurl4-openssl-dev postgresql-client-9.4 && \
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

# Install Passenger
RUN RUBY_VERSION=2.2.2 PATH=/opt/ruby/$RUBY_VERSION/bin:$PATH gem install passenger --no-rdoc --no-ri && \
    RUBY_VERSION=2.2.2 PATH=/opt/ruby/$RUBY_VERSION/bin:$PATH passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download --languages ruby
COPY nginx.conf.erb /config/nginx.conf.erb

COPY initializer.sh /usr/local/bin/initializer.sh
RUN chmod +x /usr/local/bin/initializer.sh
ENTRYPOINT ["/usr/local/bin/initializer.sh"]
