FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends kea-dhcp4-server \
 && rm -rf /var/lib/apt/lists/*
