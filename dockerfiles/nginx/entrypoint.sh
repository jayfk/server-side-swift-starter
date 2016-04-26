#!/bin/bash
set -e
# creates the .htpasswd file for the admin interface
printf "${ADMIN_USER}:$(openssl passwd -crypt ${ADMIN_PASSWORD})\n" > /etc/nginx/admin.htpasswd
exec "$@"
