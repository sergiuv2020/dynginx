#!/bin/bash
set -e

FULLENV="$SERVICE_1,$SERVICE_2,$SERVICE_3,$SERVICE_4,$SERVICE_5"
IFS=',' read -r -a array <<< "$FULLENV"
## now loop through the above array
for i in "${array[@]}"
do
   path=$(sed -e "s/:.*//g" <<< "$i")
   locations="$locations\n\t\t\tlocation /$path {\n\t\t\t\tproxy_pass http://upstream$path/$path;\nproxy_set_header Host \$host;\nproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\nproxy_set_header X-Forwarded-Server \$host;\nproxy_set_header X-Real-IP \$remote_addr;\n\t\t\t}\n"
   i=$(sed -e "s/$path://g" <<< "$i")
   IFS='/' read -r -a backends <<< "$i"
   for i in "${backends[@]}"
   do
      upstream="\t\t$upstream\n\t\t\t$i;"
   done
   upstreams="$upstreams\n\t\tupstream upstream$path {$upstream\n\t\t}\n"
   upstream=""
done
locations="\t\t$locations\n\t\t}\n"
upstreams="\t\t$upstreams\n}"
sed -ie "s/listen.*/listen $NGINX_PORT;/g" /etc/nginx/nginx.conf
sed -ie "s/rewrite.*/rewrite ^/$ /$NGINX_REWRITE_PATH;/g" /etc/nginx/nginx.conf
echo -en $locations >> /etc/nginx/nginx.conf
echo -en $upstreams >> /etc/nginx/nginx.conf

exec nginx
