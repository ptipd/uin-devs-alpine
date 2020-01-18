#!/bin/sh
set -e
rm -f /run/apache2/httpd.pid
exec httpd -DFOREGROUND -f /etc/apache2/httpd.conf "$@"
