FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends nginx libnginx-mod-rtmp curl \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/www/hls
COPY nginx.conf /etc/nginx/nginx.conf
RUN nginx -t
EXPOSE 80 1935
CMD ["nginx", "-g", "daemon off;"]
