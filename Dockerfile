FROM nginx

MAINTAINER Sergiu Vidrascu vsergiu@hotmail.com

COPY nginx.conf /etc/nginx/nginx.conf
COPY startnginx.sh /etc/nginx/

ENTRYPOINT ["/etc/nginx/startnginx.sh"]
