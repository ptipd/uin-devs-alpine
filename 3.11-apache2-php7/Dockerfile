FROM ptipd/uin-base-alpine:1.1_3.11

ARG CFG_ID
ARG APP_BUILD

RUN printf "Build of ${APP_BUILD}, date: %s\n" `date -u +"%Y-%m-%dT%H:%M:%SZ"` >> /etc/BUILD && \
    #
    # install web server and php:
    apk add --no-cache php7-apache2 apache2-utils git \
        php7-intl php7-pdo_mysql php7-mbstring php7-opcache \
        php7-ldap php7-gd php7-json php7-curl php7-pdo php7-mysqli php7-simplexml && \
    #
    # prepare apache settings:
    addgroup -g ${CFG_ID} cfg && \
    adduser -D -H -u ${CFG_ID} -G cfg -s /sbin/nologin -h /opt cfg && \
    mkdir -p /var/www/html && \
    sed -i 's/Listen 80/Listen 0.0.0.0:80/' /etc/apache2/httpd.conf && \
    sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/apache2/httpd.conf && \
    sed -i 's#^DocumentRoot ".*#DocumentRoot "/var/www/html"#g' /etc/apache2/httpd.conf && \
    sed -i 's/AllowOverride [Nn]one/AllowOverride All/' /etc/apache2/httpd.conf && \
    sed -i 's/^#ServerName.*/ServerName webAlpinePHP/' /etc/apache2/httpd.conf && \
    sed -i 's#Directory "/var/www/localhost/htdocs.*#Directory "/var/www/html">#g' /etc/apache2/httpd.conf && \
    sed -i 's/Options Indexes/Options/g' /etc/apache2/httpd.conf && \
    #
    # prepare sample web:
    echo '<html><body>It work!</body></html>' > /var/www/html/index.html && \
    true

COPY base/entpoint.sh /app

EXPOSE 80
STOPSIGNAL SIGWINCH

ENTRYPOINT /app
