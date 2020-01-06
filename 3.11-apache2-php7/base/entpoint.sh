#!/bin/sh
set -e

# Apache gets grumpy about PID files pre-existing
rm -f /run/apache2/httpd.pid
[ -d /app/html ] || {
	mkdir /app/html
	chown -R apache:www-data /app/html
}

exec httpd -DFOREGROUND -f /etc/apache2/httpd.conf "$@"
