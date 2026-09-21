FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends bind9 bind9-utils bind9-dnsutils \
 && rm -rf /var/lib/apt/lists/*
COPY named.conf /etc/bind/named.conf
COPY db.asir.test /etc/bind/db.asir.test
RUN named-checkconf /etc/bind/named.conf \
 && named-checkzone asir.test /etc/bind/db.asir.test
EXPOSE 53/tcp 53/udp
CMD ["named", "-g", "-4", "-c", "/etc/bind/named.conf"]
