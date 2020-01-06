FROM ptipd/uin-base-alpine:3.11

MAINTAINER luxmile <luxmile@gmail.com>

VOLUME /app

RUN printf "Build of ptipd/uin-base-alpine:3.11, date: %s\n" `date -u +"%Y-%m-%dT%H:%M:%SZ"` >> /etc/BUILD && \
    #
    # install web server and php:
    apk add --no-cache php7-apache2 apache2-utils && \
    apk add --no-cache php7-intl php7-pdo_mysql php7-mbstring php7-opcache php7-ldap php7-gd php7-json php7-curl php7-pdo php7-mysqli php7-simplexml && \
    #
    # prepare http root folder:
    mkdir -p /app/{html,cgi-bin} && \
    chown -R apache:www-data /app && \
    #
    # prepare apache settings:
    sed -i 's#^DocumentRoot ".*#DocumentRoot "/app/html"#g' /etc/apache2/httpd.conf && \
    sed -i 's/AllowOverride [Nn]one/AllowOverride All/' /etc/apache2/httpd.conf && \
    sed -i 's#^ServerRoot .*#ServerRoot /app#g'  /etc/apache2/httpd.conf && \
    sed -i 's/^#ServerName.*/ServerName webAlpinePHP/' /etc/apache2/httpd.conf && \
    sed -i 's#Directory "/var/www/localhost/htdocs.*#Directory "/app/html">#g' /etc/apache2/httpd.conf && \
    sed -i 's#Directory "/var/www/localhost/cgi-bin.*#Directory "/app/cgi-bin">#g' /etc/apache2/httpd.conf && \
    sed -i 's/Options Indexes/Options/g' /etc/apache2/httpd.conf

COPY base/entpoint.sh /usr/local/bin/

EXPOSE 80

ENTRYPOINT /usr/local/bin/entpoint.sh
