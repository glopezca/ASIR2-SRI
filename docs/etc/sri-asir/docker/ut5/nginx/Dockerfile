FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends nginx curl \
 && rm -rf /var/lib/apt/lists/*
COPY default.conf /etc/nginx/sites-available/default
RUN nginx -t
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
