FROM ptipd/uin-base-alpine:3.11

MAINTAINER luxmile <luxmile@gmail.com>

RUN apk add php7-apache2 && \
    rm -rf /var/cache/apk/*

# Set environment variables.
ENV HOME /root

# Define default command.
CMD ["/bin/bash"]
