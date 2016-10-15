FROM nginx

MAINTAINER Sergiu Vidrascu vsergiu@hotmail.com

COPY nginx* /etc/nginx/

ENTRYPOINT ["/etc/nginx/nginxstart.sh"]
