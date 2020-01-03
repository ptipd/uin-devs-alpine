FROM ptipd/uin-base-alpine:3.11

MAINTAINER luxmile <luxmile@gmail.com>

RUN printf "Build of ptipd/uin-base-alpine:3.11, date: %s\n" `date -u +"%Y-%m-%dT%H:%M:%SZ"` >> /etc/BUILD && \
    # install web server and php:
    apk add php7-apache2 apache2-utils && \
    apk add php7-intl php7-pdo_mysql php7-mbstring php7-opcache php7-ldap php7-gd php7-json php7-curl php7-pdo php7-mysqli php7-simplexml && \
    # prepare http root folder:
    mkdir /app/ && chown -R apache.www-data /app && \
    # prepare apache settings:
    sed -i 's#^DocumentRoot ".*#DocumentRoot "/app/html"#g' /etc/apache2/httpd.conf && \
    sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /etc/apache2/httpd.conf && \
    sed -i 's#^ServerRoot .*#ServerRoot /app#g'  /etc/apache2/httpd.conf && \
    sed -i 's/^#ServerName.*/ServerName webproxy/' /etc/apache2/httpd.conf && \
    sed -i 's#^IncludeOptional /etc/apache2/conf#IncludeOptional /app/config/conf#g' /etc/apache2/httpd.conf && \
    sed -i 's#PidFile "/run/.*#Pidfile "/app/run/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \
    sed -i 's#Directory "/var/www/localhost/htdocs.*#Directory "/app/html" >#g' /etc/apache2/httpd.conf && \
    sed -i 's#Directory "/var/www/localhost/cgi-bin.*#Directory "/app/cgi-bin" >#g' /etc/apache2/httpd.conf && \
    # ..
    sed -i 's#/var/log/apache2/#/app/logs/#g' /etc/logrotate.d/apache2 && \
    sed -i 's/Options Indexes/Options /g' /etc/apache2/httpd.conf && \
    # cleanup:
    rm -rf /var/cache/apk/*

VOLUME /app

EXPOSE 80 443
