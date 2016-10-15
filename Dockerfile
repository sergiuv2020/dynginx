FROM nginx

MAINTAINER Sergiu Vidrascu vsergiu@hotmail.com

COPY nginx.conf /etc/nginx/nginx.conf
COPY startnginx.sh /startnginx.sh

ENTRYPOINT ["/startnginx.sh"]
