FROM nginx:1.9
COPY ./dockerfiles/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./dockerfiles/nginx/admin /var/www/admin
COPY ./static /var/www/static

COPY ./dockerfiles/nginx/entrypoint.sh "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]