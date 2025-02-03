FROM nginx:1.27

COPY nginx.conf /etc/nginx/nginx.conf
COPY default-page/index.html /usr/share/nginx/html/
