FROM ptipd/uin-base-alpine:3.11

MAINTAINER luxmile <luxmile@gmail.com>

RUN apk add php7-apache2 && \
    apk add php7-intl php7-pdo_mysql php7-mbstring php7-opcache php7-ldap php7-gd php7-json php7-curl php7-pdo php7-mysqli php7-simplexml && \
    rm -rf /var/cache/apk/*

# Set environment variables.
ENV HOME /root

# Define default command.
CMD ["/bin/bash"]
